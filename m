From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: I would like to work on removing GlobalMid_Lock as my first task ...
Date: Wed, 30 May 2012 07:38:47 -0700
Message-ID: <CACyXjPxLq_3tVNvxUbv9+npEv7xB2MhThnKVMe-9E=ExgHrcJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

I find it easier to get to know a body of code if I have a specific goa=
l.

If no one has any objections I would like to work on removing
GlobalMid_Lock (or at least, moving it into struct TCP_Server_Info.)

Which branch should I work in? I can see:

  master
* smb2-dev
  remotes/origin/HEAD -> origin/master
  remotes/origin/cifs-patches
  remotes/origin/for-next
  remotes/origin/master
  remotes/origin/smb2-3.4
  remotes/origin/smb2-dev
  remotes/origin/smb2-dev-prev
  remotes/origin/smb2-dev2

or perhaps I should create my own for the moment?

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
