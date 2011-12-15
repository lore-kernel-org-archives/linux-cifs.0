From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 00/12] cifscreds: cleanup and overhaul of cifscreds utility
Date: Thu, 15 Dec 2011 13:12:04 -0500
Message-ID: <1323972736-15804-1-git-send-email-jlayton@samba.org>
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

This patch is a second pass at morphing it into a tool that's more like
what we need. I believe with this, I'll be able to roll some kernel
patches that can use the stashed key for establishing sessions.

I've made a few changes since the last set:

- combine some of the earlier patches so it's a smaller set

- I've dropped the patch to make key_search use keyctl_search. I'd still
  like to do this differently, but for now it's not possible to do so
  and protect the key payload

The idea here is that we want to be able to allow users to stash their
NTLM credentials in the kernel, so that it's possible to establish a
session on the fly when that user walks into a multiuser mount.

To that end, there are a number of changes that I'm proposing:

- a number of structural cleanups that may make this code more amenable
  to conversion to a library later and that make it easier to maintain

- hang these off of the session keyring instead of the uid keyring. I
  believe this will make this more friendly for use in containers and
  may make it harder to compromise the user's password.

- instead of having the domain as an optional parameter, allow the user
  to specify it in lieu of the hostname. During session setup, the kernel can
  first look for a host-specific key, and then fall back to looking for
  one that matches the domain if a host key isn't found.

There are still some things that need to be done to make this really
usable:

- a manpage

- kernel patches that can make these keys usable

Comments and suggestions welcome...

Jeff Layton (12):
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
  cifscreds: further restrict permissions on keys

 cifscreds.c  |  257 +++++++++++++++++++++++++++++-----------------------------
 mount.cifs.c |   11 ---
 util.c       |   13 +++
 util.h       |    1 +
 4 files changed, 141 insertions(+), 141 deletions(-)
