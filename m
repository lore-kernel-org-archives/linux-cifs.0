From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Patch series reviews
Date: Sat, 12 Jul 2014 20:18:39 -0500
Message-ID: <CAH2r5mtOGn02nU9FVgGB0eUt+o7+=XuR1VjMPiHEi0m7P-cyhQ@mail.gmail.com>
References: <CAH2r5muVJjqdnPnw--LsOim5ximr=uTS_7avBP2i8kLdx4agAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muVJjqdnPnw--LsOim5ximr=uTS_7avBP2i8kLdx4agAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have temporarily merged most (all but the last two) of your smb3
multicredit series into cifs-2.6.git for-next, but I don't see signed
off/reviewed-by/acked-by for your series for any patches beyond these
in the series (which were acked by Jeff).  Are there others with
reviewed-by feedback that you would like me to include.

commit 8f57fd1cea32316b3ae41ee520b938089bee761b
Author: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date:   Thu Jun 19 15:28:37 2014 +0400

    CIFS: Separate page sending from writepages

    Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
    Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

commit fecd99690172bfec337c489687842e29906b2575
Author: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date:   Thu Jun 19 15:01:03 2014 +0400

    CIFS: Separate page processing from writepages

    Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
    Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>




-- 
Thanks,

Steve
