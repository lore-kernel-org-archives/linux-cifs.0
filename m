From: Mark Syms <Mark.Syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] CIFS: handle guest access errors to Windows shares
Date: Fri, 2 Dec 2016 16:25:40 +0000
Message-ID: <856abc11c5864627bfcdea9ce0933465@AMSPEX02CL02.citrite.net>
References: <20161129113646.13360-2-mark.syms@citrix.com>
 <mpszikis34d.fsf@suse.com>
 <0d4b27917f3e4a90a19342a7e27b5d9f@AMSPEX02CL02.citrite.net>
 <mpswpfkswko.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
To: =?iso-8859-1?Q?Aur=E9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpswpfkswko.fsf-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I've just tried a plain vanilla Debian testing machine with the vendor 4.8.0 kernel and the issue reproduces.

Now, interestingly, if I issue the same mount command to a WS2016 machine configured in the same way as a Win8.1 machine it fails with permission denied as we'd expect and doesn't go into the DFS chase process. So, this appears to be something that is specific to connecting SMB to client grade OS machines.

	Mark

-----Original Message-----
From: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Aurélien Aptel
Sent: 30 November 2016 17:32
To: Mark Syms <Mark.Syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>; sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH] CIFS: handle guest access errors to Windows shares

Hi Mark,

New setup

  PS> net user guest /activate:no
  PS> mkdir C:\guestshare
  PS> icacls C:\guestshare /grant 'Everyone:(OI)(CI)F'
  PS> new-smbshare -name guestshare -path C:\guestshare -fullaccess Everyone

I've tested v3.10, v4.4, master, master+your patch using default options (empty or no user "NU") and user=abc (U).

NT_LOGON_FAILURE in session setup: LF
This is what you seem to have in 3.10.

NT_ACCESS_DENIED in tree connect to the share: AD This is what you get before your infinite loop.

             |   NU       U
-------------------------------- 
3.10         |   LF       LF
4.4          |   LF       LF
master       |   AD       LF
master+patch |   AD       LF

No infinite DFS loop :(
All these issues result in mount failing very fast with permission denied.

I guess it could be from either the Windows version or the share/folder ACL. A deeper analysis of the packets might reveal more.

In any case I did not notice any issues for on a basic DFS setup with the patch so I don't think it introduced any regressions, which is probably all that matters. It still bothers me a little I couldn't hit the bug.

I've included kernel output w/ debugging output and network capture of my tests if anyone want to have a look at it. (master+patch = ml-guestfix).

Reviewed-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
