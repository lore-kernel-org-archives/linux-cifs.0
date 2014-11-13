From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH] common: enable tests that require scratch device on CIFS
Date: Thu, 13 Nov 2014 14:28:24 +1100
Message-ID: <20141113032824.GB28565@dastard>
References: <1415617191-17246-1-git-send-email-eguan@redhat.com>
 <CAH2r5muXH7HSoM0TQUsPXq1RM-dLdZSfzuOKK1zZdKe0OANAhg@mail.gmail.com>
 <20141110160309.GI2863@dhcp-13-216.nay.redhat.com>
 <CAH2r5mtCPVt7+fyCjvDrLtOSzX1-+YQ_ZPhyU5gjFP7c1DJFKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtCPVt7+fyCjvDrLtOSzX1-+YQ_ZPhyU5gjFP7c1DJFKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

[ please don't top post. ]

On Wed, Nov 12, 2014 at 05:26:13PM -0600, Steve French wrote:
> I get newly enabled test 294 passing on cifs mounts to Samba.
> 
> What is best way to get the mount options passed to the mount of
> scratch dev so it doesn't prompt for it?

# MOUNT_OPTIONS="-o ...." ./check -g auto

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
