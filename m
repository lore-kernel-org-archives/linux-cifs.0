From: Karolin Varner <karo-vKgvxitQLsusTnJN9+BGXg@public.gmane.org>
Subject: getcifsacl working, but UID/GID mapping is not
Date: Tue, 11 Oct 2016 09:57:05 +0200
Message-ID: <d1e764f3-c732-c20b-40cd-dfbc51414524@cupdev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I was just trying to set up a Samba server at my company that would
mirror one of the existing windows servers and integrate well with
the Windows ACL and Active Directory.

My plan was to mount both the windows server and the samba server using
CIFS with -o winacl and rsync from windows to linux using -X (preserve xattrs);
since CIFS exposes the windows ACLs as the system.cifs_acl xattr, this
should also copy the windows ACLs.

The Samba server and the AD integration seem to work well; I can set
ACLs on the Samba File Server, log in as a user from AD and see the AD
users on my local system (`getent passwd`/`getent group`).

Now, unfortunately I can't get the CIFS UID/GID mapping to work: I can
mount the windows share, read files, write files, create directories.
I can also read the Windows ACLs (`getcifsacl`) with the user names mapped
by winbind, and even change permissions using chmod/chown.

The user/group then show UP in the ACL and I can see the permissions
changed in the normal `ls` output.
Unfortunately, I can not read the ACLs using `attr -g system.cifs_acl`
and the UID/GID of each file is just set to the fallback user/group.

For some files – when `ls`ing – I get the error message below:

  CIFS VFS: cifs_acl_to_fattr: error -13 getting sec desc

and sometimes I see this error:

  Oct 10 13:41:55 ... cifs.idmap[15777]: key description: ...
  Oct 10 13:41:55 ... cifs.idmap[15777]: Unable to convert ... to UID: Some IDs could not be mapped.

Any ideas?

Thank You very much!
Karolin Varner
