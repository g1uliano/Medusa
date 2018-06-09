# -*- coding: utf-8 -*-
"""Subliminal custom utils."""
from __future__ import unicode_literals

import hashlib
import io


def hash_itasa(video_path):
    """Compute a hash using ItaSA's algorithm.

    :param str video_path: path of the video.
    :return: the hash.
    :rtype: str
    """
    readsize = 1024 * 1024 * 10
    with io.open(video_path, 'rb') as f:
        data = f.read(readsize)
    return hashlib.md5(data).hexdigest()
