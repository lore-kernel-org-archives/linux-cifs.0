From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How to test multiusermount?
Date: Tue, 1 Nov 2011 00:12:21 +0100
Message-ID: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I would like to test the multiusermounts?

I know to set:

 echo 1 > /proc/fs/cifs/MultiuserMount

and add an option to the mount command, but I can remember/read somewhere
that one have to add some mapping somehwere:

local user : remote user
...

Is this correct?

Stef Bon
