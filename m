From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Sat, 8 Oct 2011 18:57:19 -0500
Message-ID: <CAH2r5mtiW11WLmO3KcmgE_cSVbdkW48qf=WDE+N6Vuz4Y04iXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 2838888f3f268344d42ac088c8abcff91c505ced:
  Linus Torvalds (1):
        Merge git://git.samba.org/sfrench/cifs-2.6

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Steve French (1):
      [CIFS] Fix first time message on mount, ntlmv2 upgrade delayed to 3.2

 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
Thanks,

Steve
