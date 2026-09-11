#!/bin/bash
# Example config for run_benchmark.sh.
#
# Copy this file OUTSIDE the lightning-pose repo before editing it (same
# convention as scripts/hyper-sweep/), e.g.:
#
#   cp scripts/inference-timing/config.example.sh ~/my_inference_config.sh
#   # edit ~/my_inference_config.sh to point at your own model dirs/videos
#   bash scripts/inference-timing/run_benchmark.sh --config ~/my_inference_config.sh
#
# All paths below are just placeholders -- replace them with your own.

# --- Model panels -----------------------------------------------------
# One entry per model/dataset you want a panel for in the final figure.
# Format (pipe-delimited): label|model_dir|dataset_dir|video_paths
#   - label:        short name used in filenames and plot legends
#   - model_dir:    trained Lightning Pose model directory
#   - dataset_dir:  dataset dir override, or empty string to use the
#                   model's own config as-is (data.data_dir/data.video_dir
#                   hydra overrides are only applied if this is non-empty)
#   - video_paths:  comma-separated video file path(s) to run prediction on.
#                   One path for single-view models; one path per view (in
#                   the order the model's config expects) for multiview
#                   models.
MODEL_PANELS=(
  "resnet50-singleview|/path/to/models/resnet50_singleview||/path/to/videos/test_video.mp4"
  "vits-dinov2-multiview|/path/to/models/vits_dinov2_multiview|/path/to/dataset|/path/to/videos/cam1.mp4,/path/to/videos/cam2.mp4,/path/to/videos/cam3.mp4"
)

# --- Sweep dimensions ---------------------------------------------------
# Precision/runtime variants to benchmark. Must be a subset of the choices
# hardcoded in benchmark_single_config.py's VARIANT_CHOICES.
VARIANTS=(eager_fp32 eager_fp16 compile_fp16 onnx_fp16 tensorrt_fp16)

# Video decoder backends to benchmark. "opencv" is a CPU-side fallback that
# works everywhere (no DALI/PyNvVideoCodec install required) but is slower;
# useful for a quick sanity check on a machine without GPU-decode libraries.
DECODERS=(dali pynvvc)

# --- Timing parameters ---------------------------------------------------
NUM_WARMUP=1
NUM_REPEATS=3

# --- Output ---------------------------------------------------------------
# Directory where per-panel CSVs and the final plot are written. Created if
# it doesn't already exist.
OUTPUT_DIR="$HOME/inference_timing_results"

# Optional: override the GPU label used in filenames/plot legends (e.g. if
# torch.cuda.get_device_name(0) returns something unwieldy). Leave empty to
# auto-detect.
GPU_LABEL=""

# Optional: batch sizes passed through to model.export() for onnx/tensorrt
# variants.
MAX_BATCH_SIZE=8
OPT_BATCH_SIZE=1
