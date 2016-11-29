From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] CIFS: handle guest access errors to Windows shares
Date: Tue, 29 Nov 2016 16:43:46 +0100
Message-ID: <mpszikis34d.fsf@suse.com>
References: <20161129113646.13360-2-mark.syms@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: mark.syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
To: Mark Syms <mark.syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129113646.13360-2-mark.syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I've tried setting up a guest share on a Windows 2016 server and
mounting it before and after your patch. Powershell setup follows.

To setup the share I had to enable the guest account

  PS> net user guest /active:yes

Make the directory, give perms, make share

  PS> mkdir C:\guestshare
  PS> icacls C:\guestshare /grant 'Everyone:(OI)(CI)F'
  PS> New-SmbShare -name guestshare -path C:\guestshare -fullaccess Everyone

After this, smbclient -N works:

  % smbclient //$(vmip win2016)/guestshare -N
  OS=[Windows Server 2016 Standard 14393] Server=[Windows Server 2016 Standard 6.3]
  smb: \> ^D

On the wire:

  CLIENT -> SERVER SMB Negotiate Protocol Request
  SERVER -> CLIENT SMB Negotiate Protocol Response
  CLIENT -> SERVER SMB Session Setup AndX Request, NTLMSSP_NEGOTIATE
  SERVER -> CLIENT SMB Session Setup AndX Response, NTLMSSP_CHALLENGE, Error: STATUS_MORE_PROCESSING_REQUIRED
  CLIENT -> SERVER SMB Session Setup AndX Request, NTLMSSP_AUTH, User: WORKGROUP\aaptel
  SERVER -> CLIENT SMB Session Setup AndX Response
  |                    Action: 0x0001
  |                    .... .... .... ...1 = Guest: Logged in as GUEST
  CLIENT -> SERVER SMB Tree Connect AndX Request, Path: \\SERVER\IPC$
  SERVER -> CLIENT SMB Tree Connect AndX Response
  CLIENT -> SERVER SMB Trans2 Request, GET_DFS_REFERRAL, File: \SERVER\guestshare
  SERVER -> CLIENT SMB Trans2 Response, GET_DFS_REFERRAL, Error: STATUS_NOT_FOUND
  CLIENT -> SERVER SMB Tree Disconnect Request
  SERVER -> CLIENT SMB Tree Disconnect Response
  CLIENT -> SERVER SMB Tree Connect AndX Request, Path: \\SERVER\GUESTSHARE
  SERVER -> CLIENT SMB Tree Connect AndX Response
  CLIENT -> SERVER SMB Echo Request
  SERVER -> CLIENT SMB Echo Response
  CLIENT -> SERVER SMB Tree Disconnect Request
  SERVER -> CLIENT SMB Tree Disconnect Response

But from cifs.ko master (with or without your patch) I get this:

  # mount -t cifs -vvv //WS2016/guestshare /mnt -o ip=10.160.65.202,guest
  CIFS VFS: SMB signature verification returned error = -13
  CIFS VFS: SMB signature verification returned error = -13
  CIFS VFS: cifs_mount failed w/return code = -13
  mount error(13): Permission denied
  Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

On the wire:

  CLIENT -> SERVER SMB Negotiate Protocol Request
  SERVER -> CLIENT SMB Negotiate Protocol Response
  CLIENT -> SERVER SMB Session Setup AndX Request, NTLMSSP_NEGOTIATE
  SERVER -> CLIENT SMB Session Setup AndX Response, NTLMSSP_CHALLENGE, Error: STATUS_MORE_PROCESSING_REQUIRED
  CLIENT -> SERVER SMB Session Setup AndX Request, NTLMSSP_AUTH, User: SUSE\
  SERVER -> CLIENT SMB Session Setup AndX Response
  |                    Action: 0x0000
  |                    .... .... .... ...0 = Guest: Not logged in as GUEST
  CLIENT -> SERVER SMB Tree Connect AndX Request, Path: \\WS2016\guestshare
  SERVER -> CLIENT SMB Tree Connect AndX Response, Error: STATUS_ACCESS_DENIED
  CLIENT -> SERVER SMB Logoff AndX Request
  SERVER -> CLIENT SMB Logoff AndX Response

So why is it failing in this case? The server is an AD of the domain
SUSE. I gave `guest` mount option but that option is actually ignored on
purpose.

Since I gave no username, domain or password cifs.ko tries to login with
"SUSE\". In the Session Setup response this results in the Action field
being set to "non-guest" and the tree connect laters fails.

smbclient uses "WORKGROUP\<my user name>" when I login with -N. If I use
-U 'SUSE\' like cifs.ko does it fails. Similarly, if I use a non-empty,
non-existing user in cifs.ko (e.g. "SUSE\xyz" instead of "SUSE\", it
works).

So to summarize I couldn't reproduce Mark's bug against Window Server
2016 (same behaviour with and without the patch). But I have discovered
that the way cifs.ko picks the username/domain when none are provided is
not correct in my scenario.

...

After re-reading Mark email I've just realized he said it happens when
using the guest account to do a tree connect on a share that *requires* a
real account. So with the guest account still activated I've added deny
rules:

  PS> icacls C:\guestshare /deny 'Guest:(OI)(CI)F'
  PS> Block-SmbShareAccess -name guestshare -accountname guest -force

But the tree connect still works with both cifs.ko and smbclient. What
is denies with thoses rules are anything past the connexion it
seems. cifs.ko fails for permissions reasons because it tries to query
things at the root level as part of mounting. In anycase I was not able
to make cifs.ko hang during any of my tests.

I would be curious to see a network trace of your scenario.

--
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
