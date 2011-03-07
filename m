From: "Chen, Xianwen" <xianwen.chen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: uid specified user can't access mounted Window share
Date: Mon, 7 Mar 2011 10:02:03 +0100
Message-ID: <AANLkTikh8+k3Yt5La0uPMnENGC-DXYqAAv5NCVau-803@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi fellow Linuxers,

I need some hints on granting access to a non-root user for mounted
Windows share.

The share is mounted via
  mount.cifs //server/share/media/h/ -o user=user1 domain=dmn uid=user1

However, user1 can't write to /media/h.

Any comment will be appreciated!

Xianwen
