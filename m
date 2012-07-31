From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Howto mount cifs from c?
Date: Tue, 31 Jul 2012 19:49:23 +0200
Message-ID: <CANXojczjroEONLHbmauimAh_M-4ZuHMJ=3LTnHAXMSahc9WMRA@mail.gmail.com>
References: <CANXojcz_p23rcNo3gPiAjJ95M0ry+p5Q_5hyYO0TF==0VpKBqg@mail.gmail.com>
	<CANXojczSt+3pyiEH_RoQa4TjA+7H1pmNJrpbJsX3iQA1Vr1O_A@mail.gmail.com>
	<CADT32eJcEm=UnXaCfAva1aXWptxBGEmBAYgeJnqU7nVtC7T4nA@mail.gmail.com>
	<CANXojcwnCQQOEBk3=sM_61Uq7BunLyUvx67WzNGxbRszcgp-fA@mail.gmail.com>
	<CADT32e+Rx3L12ciJXL3VsKnOpsAFiedZXAU78-jZromi7dioNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+Rx3L12ciJXL3VsKnOpsAFiedZXAU78-jZromi7dioNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Aha, I didn't know that,

now I get:


kernel: fs/cifs/cifsfs.c: Devname: //SCLFS20091030/public flags: 0
kernel: fs/cifs/connect.c: Domain name set
kernel: fs/cifs/connect.c: Username: sbon
kernel: fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
kernel: fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 118 with uid: 0
kernel: fs/cifs/connect.c: UNC:
\\SCLFS20091030\p//SCLFS20091030/public ip:
SCLFS20091030\p//SCLFS20091030/public
kernel: fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 118) rc = -22
kernel: CIFS VFS: cifs_mount failed w/return code = -22

Obviously something goes wrong with the mountcommand:

mount_resource: mount //SCLFS20091030/public
/mnt/fuse-workspace/65e9e42684129ad79f96d981c665cae1 cifs
user=sbon,password=sjbon0701,uid=1000,gid=1000,domain=BONONLINE,rw,acl,user_xattr,cifsacl,posixpaths,nodfs,unc=\\SCLFS20091030\p//SCLFS20091030/public

The original mountcommand in my programm adds the ip address, which is
totally overwritten.

I guess everything get messed up with the backslashes. The code I use:

/* add the unc */

*(vfsdata+len0)='\\';
len0++;
*(vfsdata+len0)='\\';
len0++;

memcpy(vfsdata+len0, smb_server->name, strlen(smb_server->name));
len0+=strlen(smb_server->name);

*(vfsdata+len0)='\\';
len0++;

memcpy(vfsdata+len0, smb_share->name, strlen(smb_share->name));
len0+=strlen(smb_share->name);

if (strlen(smb_server->ipv4address)>0) {

         /* add ip */

         len1=sprintf(vfsdata+len0, ",ip=%s", smb_server->ipv4address);
         len0+=len1;

}


Some hint??

Stef
