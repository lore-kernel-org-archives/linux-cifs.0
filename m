From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Byte Range lock performance fixes for cifs
Date: Thu, 13 Oct 2011 20:01:15 -0500
Message-ID: <CAH2r5ms+44SfqqEQJKXC6JugH9UDrEEE0+OZPqAHLqpcdD46_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Has anyone reviewed Pavel's recent patch series on byte range locks? I
have reviewed and merged his earlier lock related ones, but have not
finished looking at these.  They are an interesting series.  In the
future these will be even more useful (with cifs we often have oplock,
but with smb2.1, the addition of leases, means that we are more likely
to have caching privilege for a file than in the past since it can
handle upgrades of leases and reacquiring leases)

CIFS: Make cifs_push_locks send as many locks at once...
CIFS: Send as many mandatory unlock ranges at once...
CIFS: Implement caching mechanism for posix brlocks
CIFS: Implement caching mechanism for mandatory brlocks

They were posted on the linux-cifs list but are also at:
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commit;h=d4a489bea84714529f8c0793179a5ea5e89fb5c9
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commit;h=6def2122f7ab8882b837ec6768d2d2bc2bb87512
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commit;h=f21c9062410dc790136e4dedc0ab05c766c497f8
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commit;h=ec278d8fdcb65df02cc88c21ecbbc870a20039a3
-- 
Thanks,

Steve
