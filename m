From: Tejun Heo <tj@kernel.org>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 08:37:57 -0800
Message-ID: <20120216163757.GI24986@google.com>
References: <20120216162634.GE24986@google.com>
 <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org>
 <32626.1329405744@redhat.com>
 <2050.1329410151@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Steve French <sfrench@samba.org>, Chris Ball <cjb@laptop.org>,
	David Airlie <airlied@linux.ie>,
	Linux-pm mailing list <linux-pm@vger.kernel.org>,
	linux-cifs@vger.kernel.org, linux-mmc@vger.kernel.org,
	dri-devel@lists.freedesktop.org, keyrings@linux-nfs.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2050.1329410151@redhat.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Feb 16, 2012 at 04:35:51PM +0000, David Howells wrote:
> The key_garbage_collector work item is marked neither freezable nor
> unfreezable that I can see.

Heh, was too brief apparently. :)

I was trying to say that if it doesn't require freezing, please don't
put it on a freezable workqueue.  So, IOW, I was just saying that
nothing should change for key_garbage_collector.

Thanks.

-- 
tejun
