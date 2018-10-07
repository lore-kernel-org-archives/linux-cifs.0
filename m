From: Rodrigo Freire <rfreire@redhat.com>
Subject: [PATCH v3 0/2] CIFS: Info-level log support, print message when attempting mount.
Date: Sun,  7 Oct 2018 12:21:24 -0300
Message-ID: <cover.1538873915.git.rfreire@redhat.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, piastryyy@gmail.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Steve,
>From our conversation over v2, I came out with this v3 patch, which I broke
in two commits:

* The first commit in cifs_debug.h, creating the cifs_info() function.
  - The aim of this commit is to allow to the developer to be able to print
    informational-level data without having to use pr_info, pr_notice etc,
    in line with other filesystems.
    . One interesting and noteworthy feature of cifs_info() is that it is
      transparent to the CIFS_DEBUG config state, either in "y" or "n".
    . Also, by using KERN_INFO level, it can be safely filtered by a
      maintainer / administrator, without cluttering their log monitors,
      since this is a low level alert.
  - I took the liberty to not add it inside the existing pr_debug, because
    of the eventual need of some developer to print stuff that should be
    printed not only in CIFS_DEBUG mode (as there are plenty of pr_notice
    scattered over the code).
  - Also, this is not a debug but a info message, so i liked cifs_info() 
    more ;-)
  - I saw plenty of pr_notice() in CIFS code, but I resisted the urge to
    convert them to cifs_info().

* The second commit contains the code printing a cifs_info() when attempting
  a CIFS mount operation.

Appreciate your review.

V3: Created a new cifs_info() function, moved the mount attempt message to
    cifs_info

V2: Created a loop to select the right cifs_dbg message to be printed,
    considering the current system's scenario, in order to avoid a
    duplicate message or stripping out important information in
    debug.

Rodrigo Freire (2):
  CIFS: Adds information-level logging function
  CIFS: Print message when attempting a mount

 fs/cifs/cifs_debug.h | 16 ++++++++++++++++
 fs/cifs/cifsfs.c     |  7 ++++++-
 fs/cifs/transport.c  |  2 +-
 3 files changed, 23 insertions(+), 2 deletions(-)

-- 
1.8.3.1
