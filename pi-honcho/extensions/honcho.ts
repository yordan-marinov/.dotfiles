import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { spawn } from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const toolParameters = Type.Object({
  request: Type.String({ description: "Plain-text operator request to send through the honcho Pi adapter." }),
  executionMode: Type.Optional(Type.Union([
    Type.Literal("mgmt"),
    Type.Literal("local"),
  ], { description: "Adapter execution mode. Defaults to mgmt-first." })),
  profileFile: Type.Optional(Type.String({ description: "Optional profile file path passed to --profile-file." })),
  repoRoot: Type.Optional(Type.String({ description: "Optional execution-plane checkout to use instead of the default repo path." })),
});

type ToolInput = {
  request: string;
  executionMode?: "mgmt" | "local";
  profileFile?: string;
  repoRoot?: string;
};

function defaultRepoRoot(cwd: string, override?: string): string {
  if (override) return path.resolve(override);

  const envRepo = process.env.HONCHO_EXECUTION_PLANE_REPO;
  if (envRepo) return path.resolve(envRepo.replace(/^~(?=\/|$)/, os.homedir()));

  const localScript = path.join(cwd, "scripts/interfaces/run-from-pi.sh");
  if (fs.existsSync(localScript)) return cwd;

  return path.join(os.homedir(), "platform", "execution-plane");
}

function defaultProfileFile(repoRoot: string, override?: string): string | undefined {
  if (override) return override;
  if (process.env.HONCHO_PROFILE_FILE) return process.env.HONCHO_PROFILE_FILE;

  const profilesDir = path.join(repoRoot, "profiles");
  if (!fs.existsSync(profilesDir)) return undefined;

  const candidates = fs.readdirSync(profilesDir)
    .filter((name) => name.endsWith(".profile"))
    .map((name) => path.join(profilesDir, name));
  return candidates.length === 1 ? candidates[0] : undefined;
}

async function runHoncho(input: ToolInput, cwd: string, signal?: AbortSignal) {
  const repoRoot = defaultRepoRoot(cwd, input.repoRoot);
  const scriptPath = path.join(repoRoot, "scripts", "interfaces", "run-from-pi.sh");

  if (!fs.existsSync(scriptPath)) {
    throw new Error(`honcho adapter not found: ${scriptPath}`);
  }

  const args = [scriptPath, "--request", input.request, "--execution-mode", input.executionMode ?? "mgmt"];
  const profileFile = defaultProfileFile(repoRoot, input.profileFile);
  if (profileFile) args.push("--profile-file", profileFile);

  return await new Promise<{
    repoRoot: string;
    scriptPath: string;
    profileFile?: string;
    stdout: string;
    stderr: string;
    exitCode: number;
  }>((resolve, reject) => {
    const child = spawn("bash", args, {
      cwd: repoRoot,
      signal,
      env: process.env,
    });

    let stdout = "";
    let stderr = "";

    child.stdout.on("data", (chunk) => {
      stdout += String(chunk);
    });

    child.stderr.on("data", (chunk) => {
      stderr += String(chunk);
    });

    child.on("error", reject);
    child.on("close", (exitCode) => {
      resolve({
        repoRoot,
        scriptPath,
        profileFile,
        stdout: stdout.trim(),
        stderr: stderr.trim(),
        exitCode: exitCode ?? 1,
      });
    });
  });
}

function formatResult(result: {
  repoRoot: string;
  scriptPath: string;
  profileFile?: string;
  stdout: string;
  stderr: string;
  exitCode: number;
}) {
  const parts = [
    `repo: ${result.repoRoot}`,
    `script: ${result.scriptPath}`,
  ];

  if (result.profileFile) parts.push(`profile: ${result.profileFile}`);
  if (result.stdout) parts.push(`stdout:\n${result.stdout}`);
  if (result.stderr) parts.push(`stderr:\n${result.stderr}`);
  parts.push(`exit_code: ${result.exitCode}`);

  return parts.join("\n\n");
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "honcho_dispatch",
    label: "Honcho Dispatch",
    description: "Run the honcho Pi adapter against the execution-plane dispatch bridge.",
    parameters: toolParameters,
    async execute(_toolCallId, input: ToolInput, signal, _onUpdate, ctx) {
      try {
        const result = await runHoncho(input, ctx.cwd, signal ?? ctx.signal);
        return {
          content: [{ type: "text", text: formatResult(result) }],
          details: result,
          isError: result.exitCode !== 0,
        };
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        return {
          content: [{ type: "text", text: message }],
          details: { error: message },
          isError: true,
        };
      }
    },
  });

  pi.registerCommand("honcho", {
    description: "Run a plain-text request through the honcho Pi adapter",
    handler: async (args, ctx) => {
      const request = (args ?? "").trim();
      if (!request) {
        ctx.ui.notify("Usage: /honcho <request>", "error");
        return;
      }

      const result = await runHoncho({ request }, ctx.cwd);
      const level = result.exitCode === 0 ? "info" : "error";
      ctx.ui.notify(result.stdout || result.stderr || `honcho exit code ${result.exitCode}`, level);
    },
  });

  pi.on("session_start", async (_event, ctx) => {
    const repoRoot = defaultRepoRoot(ctx.cwd);
    const scriptPath = path.join(repoRoot, "scripts", "interfaces", "run-from-pi.sh");
    const status = fs.existsSync(scriptPath) ? `honcho: ${repoRoot}` : "honcho: adapter missing";
    ctx.ui.setStatus("honcho", status);
  });
}
