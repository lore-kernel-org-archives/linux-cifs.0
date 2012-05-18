From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Howto get the ipaddress from the info in mountinfo?
Date: Fri, 18 May 2012 12:32:51 +0200
Message-ID: <CANXojcz2jKGGhGTk=TacPrCagA6Xx66gUc9yvu-vviOyHvEqJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I would like to extract the ip number from the info found in mountinfo.
In mountinfo there is the mountsource, which is in netbios format, and
possibly the superoptions contains the addr field, and the unc.

Now when the ipaddr (ipv4) is there it's of course simple, but is it
always there?

Stef
