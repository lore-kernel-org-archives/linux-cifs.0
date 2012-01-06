From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/4] cifs: allow multiuser mounts with authtypes besides krb5
Date: Fri,  6 Jan 2012 14:30:43 -0500
Message-ID: <1325878247-12030-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This set fixes a couple of problems pointed out by Shirish, and also
adds a patch to warn about deprecating the old MultiuserMount code
in 3.5.

When the (newer) multiuser mount code was initially introduced for cifs,
I limited it to sec=krb5 auth. When a new user walks into a mount, we
have no way to prompt for a username and password from the kernel, so
the only auth type we could support was krb5.

This patchset extends the code to allow other auth types to use
multiuser mounts. The idea here is for users to put their username and
password for a particular server or domain into the keyring. The kernel
can then look for that key and use those credentials to establish a
session on the user's behalf.

Because of the quirkiness of keyring permissions, this patchset adds a
new key type that does not allow the keys to be read from userspace.
That should prevent compromise of the credentials by someone walking up
to the user's machine while she is away at lunch.

This patchset requires some changes to cifs-utils as well, to make it
use the new key_type, description and payload format. I sent that set
to the linux-cifs list earlier today.

Comments and review of both sets is appreciated...

Jeff Layton (4):
  keys: add a "secret" key type
  cifs: sanitize username handling
  cifs: fetch credentials out of keyring for non-krb5 auth multiuser
    mounts
  cifs: warn about impending deprecation of legacy MultiuserMount code

 fs/cifs/cifs_debug.c         |   11 ++-
 fs/cifs/cifs_spnego.c        |   10 ++-
 fs/cifs/cifsencrypt.c        |   11 ++-
 fs/cifs/connect.c            |  194 ++++++++++++++++++++++++++++++++++++++----
 include/keys/user-type.h     |    3 +-
 security/keys/internal.h     |    1 +
 security/keys/key.c          |    1 +
 security/keys/user_defined.c |   17 ++++
 8 files changed, 223 insertions(+), 25 deletions(-)

-- 
1.7.7.4
