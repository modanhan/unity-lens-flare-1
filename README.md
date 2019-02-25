# Update
For those of you using Unity's new post processing framework (Post Processing Stack v2), here's a quick ported version: https://github.com/modanhan/Unity-Lens-Flare-2019

# unity-lens-flare-1

This is an improved version of my previous lens flare implementation: https://github.com/modanhan/unity-lens-flare

This project has been updated to support Unity 2018!

# Video

Check out this video! https://www.youtube.com/watch?v=DficeB9wfV0

# Concept

Original blog post by John Chapman: http://john-chapman-graphics.blogspot.ca/2013/02/pseudo-lens-flare.html

My implementation is a simplified version of the lens flare described in this blog optimized for Unity.

# Installation

I currently do not have a package, but feel free to fork/clone the repository or download the source code.

# Usage

Attach GhostLensFlare to the camera.

HDR rendering is highly recommended. Altho not required, lens flare will not look correct without HDR and tonemapping.

Linear color space is recommended.

A test scene Main.unity is included. Notice the main camera also has bloom and tonemapping which help with the effect.

# Known Issues

This project was originally made using Unity 5.6, back when legacy image effects were a thing. The post processing framework has changed so much since then (from cinematic image effects to post processing stack v1, v2) this lens flare image effect might not fit into the new frameworks well (especially post processing stack v2!).
