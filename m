From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: xfstest progress with cifs mounts to Samba
Date: Fri, 29 Aug 2014 00:57:56 -0500
Message-ID: <CAH2r5muEGwauvSDr3KeVkiN6+kRaD8hbU+FcJCtbAGNEk_tEZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we have better fixed up the configuration required, and with
current cifs for-next branch - the xfstest runs are working better now
(mount with actimeo=0 helped in a few  tests that had been failing),
at least for the easier case of cifs mounts (with posix extensions) to
Samba 4.2-pre.

At least two tests  generic/237 (setfacl error) and generic/258
(testing for negative seconds since epoch) are still failing though
and need more analysis.

And there are a few dozen tests that are not attempted that probably
could be gotten to work.


-- 
Thanks,

Steve
