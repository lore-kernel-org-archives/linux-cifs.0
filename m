From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Howto mount cifs from c?
Date: Mon, 30 Jul 2012 01:12:46 +0200
Message-ID: <CANXojcz_p23rcNo3gPiAjJ95M0ry+p5Q_5hyYO0TF==0VpKBqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I'm writing a mount module, which can mount cifs. But I get constantly errors:

Jul 30 01:01:21 asus20110414.bononline.nl fuse-workspace[7570]:
mount_resource: mount //SCLFS20091030/public
/mnt/fuse-workspace/8b1cd1abd18e90c9f5a112627f779ee2 cifs
user=sbon,password=******,uid=1000,gid=1000,domain=BONONLINE,rw,acl,user_xattr,cifsacl,posixpaths

THis is ouput of the logging of fuse-workspace, and it tries to mount
the share //SCLFS20091030/public at
/mnt/fuse-workspace/8b1cd1abd18e90c9f5a112627f779ee2, with the
options.

I get constantly -22 errors, and nothing gets mounted. Do I have to
add the ip or something?

Stef
