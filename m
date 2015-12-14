From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/4] vfs: pull btrfs clone API to vfs layer
Date: Mon, 14 Dec 2015 17:34:03 +0100
Message-ID: <20151214163403.GA12687@lst.de>
References: <1449143992-7415-1-git-send-email-hch@lst.de> <1449143992-7415-3-git-send-email-hch@lst.de> <20151209204033.GB10582@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151209204033.GB10582-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 09, 2015 at 12:40:33PM -0800, Darrick J. Wong wrote:
> I tried this patch series on ppc64 (w/ 32-bit powerpc userland) and I think
> it needs to fix up the compat ioctl to make the vfs call...

Might need a proper signoff for Al, unless he wants to directly fold it..
