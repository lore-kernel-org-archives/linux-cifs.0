From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] cifs: allow multiuser mounts with authtypes besides krb5
Date: Fri,  6 Jan 2012 08:11:20 -0500
Message-ID: <1325855483-8846-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When the multiuser mount code was initially introduced for cifs, I
limited it to sec=krb5 auth. When a new user walks into a mount, we have
no way to prompt for a username and password from the kernel, so the
only auth type we could support was krb5.

This patchset extends the code to allow other auth types to use
multiuser mounts. The idea here is for users to put their username and
password for a particular server or domain into the keyring. The kernel
can then look for that key and use those credentials to establish a
session on the user's behalf.

Because of the quirkiness of keyring permissions, this patchset adds a
new key type that does not allow the keys to be read from userspace.
That should prevent compromise of the credentials by someone walking up
to the user's machine while she is away at lunch.

The userspace tool to stash keys in the keyring is already in
cifs-utils, but the current form will not work with this version of the
kernel patchset. A patchset that updates the tool to be suitable for
this purpose will follow.

Jeff Layton (3):
  keys: add a "secret" key type
  cifs: sanitize username handling
  cifs: fetch credentials out of keyring for non-krb5 auth multiuser
    mounts

 fs/cifs/cifs_spnego.c        |   10 ++-
 fs/cifs/cifsencrypt.c        |   11 ++-
 fs/cifs/connect.c            |  195 ++++++++++++++++++++++++++++++++++++++----
 include/keys/user-type.h     |    3 +-
 security/keys/internal.h     |    1 +
 security/keys/key.c          |    1 +
 security/keys/user_defined.c |   17 ++++
 7 files changed, 214 insertions(+), 24 deletions(-)

-- 
1.7.7.4
