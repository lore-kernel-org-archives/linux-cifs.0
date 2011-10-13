From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Should multiuser imply "noperm" mount option?
Date: Thu, 13 Oct 2011 13:12:20 -0500
Message-ID: <CAH2r5mvEq3nrx=Qu0gkn9Oaa-WYK-EuJqqNKYLQOY4QmsrgHXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If multiuser mount is enabled and we are getting and sending the
"correct" credentials - should we enable noperm by default (so we
don't do client side permission checking unless we are mounted as
single user - no multiuser)

-- 
Thanks,

Steve
