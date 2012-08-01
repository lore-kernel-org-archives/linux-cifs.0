From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Howto mount cifs from c?
Date: Wed, 1 Aug 2012 10:30:38 +0200
Message-ID: <CANXojcy+RapoY9dHXgkaCMr3D7c01bBhiJcxyU2698QwNzY_aA@mail.gmail.com>
References: <CANXojcz_p23rcNo3gPiAjJ95M0ry+p5Q_5hyYO0TF==0VpKBqg@mail.gmail.com>
	<CANXojczSt+3pyiEH_RoQa4TjA+7H1pmNJrpbJsX3iQA1Vr1O_A@mail.gmail.com>
	<CADT32eJcEm=UnXaCfAva1aXWptxBGEmBAYgeJnqU7nVtC7T4nA@mail.gmail.com>
	<CANXojcwnCQQOEBk3=sM_61Uq7BunLyUvx67WzNGxbRszcgp-fA@mail.gmail.com>
	<CADT32e+Rx3L12ciJXL3VsKnOpsAFiedZXAU78-jZromi7dioNw@mail.gmail.com>
	<CANXojczjroEONLHbmauimAh_M-4ZuHMJ=3LTnHAXMSahc9WMRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojczjroEONLHbmauimAh_M-4ZuHMJ=3LTnHAXMSahc9WMRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I've changed the options:

without unc did not work, with unc, but then with normal slashes:


mount_resource: mount //SCLFS20091030/public
/mnt/fuse-workspace/65e9e42684129ad79f96d981c665cae1 cifs
user=sbon,password=*******,uid=1000,gid=1000,domain=BONONLINE,rw,nodfs,unc=//SCLFS20091030/public,ip=192.168.0.2


kernel: fs/cifs/cifsfs.c: Devname: //SCLFS20091030/public flags: 0
kernel: fs/cifs/connect.c: Domain name set
kernel: fs/cifs/connect.c: Username: sbon
kernel: fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
kernel: fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 17 with uid: 0
kernel: fs/cifs/connect.c: UNC: \\SCLFS20091030/public ip: 192.168.0.2
kernel: fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 17) rc = -22
kernel: CIFS VFS: cifs_mount failed w/return code = -22

Any idea??

Stef
