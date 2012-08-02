From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Howto mount cifs from c?
Date: Thu, 2 Aug 2012 16:14:35 -0400
Message-ID: <20120802161435.7d1564ce@tlielax.poochiereds.net>
References: <CANXojcz_p23rcNo3gPiAjJ95M0ry+p5Q_5hyYO0TF==0VpKBqg@mail.gmail.com>
	<CANXojczSt+3pyiEH_RoQa4TjA+7H1pmNJrpbJsX3iQA1Vr1O_A@mail.gmail.com>
	<CADT32eJcEm=UnXaCfAva1aXWptxBGEmBAYgeJnqU7nVtC7T4nA@mail.gmail.com>
	<CANXojcwnCQQOEBk3=sM_61Uq7BunLyUvx67WzNGxbRszcgp-fA@mail.gmail.com>
	<CADT32e+Rx3L12ciJXL3VsKnOpsAFiedZXAU78-jZromi7dioNw@mail.gmail.com>
	<CANXojczjroEONLHbmauimAh_M-4ZuHMJ=3LTnHAXMSahc9WMRA@mail.gmail.com>
	<CANXojcy+RapoY9dHXgkaCMr3D7c01bBhiJcxyU2698QwNzY_aA@mail.gmail.com>
	<CADT32eK7WuEASsQ3pUWr9Qj74wRyaGwnEZ10XeQBF-r6d9WHUg@mail.gmail.com>
	<CANXojcyKPGYMv_6iequis+v2d67ozTk7Lw9D0=MY7WWymT=1Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojcyKPGYMv_6iequis+v2d67ozTk7Lw9D0=MY7WWymT=1Nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2 Aug 2012 19:18:36 +0200
Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Ok! Thanks a lot! If you want to to it a week later, it's fine with
> me. As long as I know someone tries to tackle it I'm very happy.
> 
> Stef
> 
> 2012/8/2 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > On Wed, Aug 1, 2012 at 3:30 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> I've changed the options:
> >>
> >> without unc did not work, with unc, but then with normal slashes:
> >>
> >>
> >> mount_resource: mount //SCLFS20091030/public
> >> /mnt/fuse-workspace/65e9e42684129ad79f96d981c665cae1 cifs
> >> user=sbon,password=*******,uid=1000,gid=1000,domain=BONONLINE,rw,nodfs,unc=//SCLFS20091030/public,ip=192.168.0.2
> >>
> >>
> >> kernel: fs/cifs/cifsfs.c: Devname: //SCLFS20091030/public flags: 0
> >> kernel: fs/cifs/connect.c: Domain name set
> >> kernel: fs/cifs/connect.c: Username: sbon
> >> kernel: fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
> >> kernel: fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 17 with uid: 0
> >> kernel: fs/cifs/connect.c: UNC: \\SCLFS20091030/public ip: 192.168.0.2
					^^^^^^^^
Your unc= parm is bogus, it requires backslashes as delimiters.

Is there some reason you're not using mount.cifs?

> >> kernel: fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 17) rc = -22
> >> kernel: CIFS VFS: cifs_mount failed w/return code = -22
> >>
> >> Any idea??
> >>
> >> Stef
> >
> > Stef, I would not be able to respond for a day or two.
> > Will spend time on this over either Friday or weekend.
> >
> > Regards,
> >
> > Shirish
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
