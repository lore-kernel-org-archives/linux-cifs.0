From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 00/15] cifscreds: cleanup and overhaul of cifscreds utility
Date: Fri,  6 Jan 2012 13:14:32 -0500
Message-ID: <1325873687-11229-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is a cleanup and overhaul of the cifscreds utility that
lives in the cifs-utils tree today. Igor Druzhinin did a wonderful job
on this when he did the original code a couple of years ago, but I did a
rather poor job at the time of communicating what we actually need for
this tool to do. Mea culpa...

This patch is a third pass at morphing it into a tool that's more like
what we need. I believe with this, I'll be able to roll some kernel
patches that can use the stashed key for establishing sessions.

I've made a few changes since the last set:

- convert the tool to use the new "secret" key_type that I'm proposing

- a manpage has been added

- the key is now prefixed with "cifs:" instead of "cifscreds:"

The idea here is that we want to be able to allow users to stash their
NTLM credentials in the kernel, so that it's possible to establish a
session on the fly when that user walks into a multiuser mount.

This set should be considered in conjunction with the kernel patchset
that I proposed earlier today:

    [PATCH 0/3] cifs: allow multiuser mounts with authtypes besides krb5


Jeff Layton (15):
  util: move getusername to util.c
  cifscreds: add unused attribute to argv parm in cifscreds_clearall
  cifscreds: eliminate domain parm from most functions
  cifscreds: remove user parameter from create_description
  cifscreds: make username part of value instead of description
  cifscreds: make usage use "return" and have callers return
  cifscreds: move option parsing into main()
  cifscreds: make username parameter optional
  cifscreds: add --domain flag
  cifscreds: loosen allowed characters in domain names
  cifscreds: use the session keyring
  cifscreds: make cifscreds use the "unreadable" keyring
  cifscreds: make key_search use keyctl_search
  cifscreds: change prefix on keys to "cifs:" instead of "cifscreds:"
  cifscreds: add a manpage

 Makefile.am   |    1 +
 cifscreds.1   |  188 ++++++++++++++++++++++++++++++++++
 cifscreds.c   |  311 +++++++++++++++++++++++++--------------------------------
 cifscreds.pod |   81 +++++++++++++++
 mount.cifs.c  |   11 --
 util.c        |   13 +++
 util.h        |    1 +
 7 files changed, 418 insertions(+), 188 deletions(-)
 create mode 100644 cifscreds.1
 create mode 100644 cifscreds.pod

-- 
1.7.7.4
