From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 1/5] cifs: implement clone_file_range operation
Date: Mon, 30 Nov 2015 10:02:34 +0100
Message-ID: <20151130090234.GB31810@lst.de>
References: <1448563859-21922-1-git-send-email-hch@lst.de> <1448563859-21922-2-git-send-email-hch@lst.de> <20151127114232.5b367b7b@g21.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151127114232.5b367b7b-TzLh5lQYVSQb1SvskN2V4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 27, 2015 at 11:42:32AM +0100, David Disseldorp wrote:
> I think that's about as close as we're going to get to clone semantics
> for cifs. It's also dispatched as a single request covering the full
> file - chunking only occurs for CIFS_IOC_COPYCHUNK_FILE based requests,
> which are implemented using FSCTL_SRV_COPYCHUNK_WRITE, and not (always)
> handled by the server as a COW clone.

Oh, I misread cifs_ioctl_clone - it does two entirely different things
based on the dup_extents parameter.  It looked like it did both
of them in the dup_extents case.  Re-reading the code it seems close
enough, although the client side samping of the file size seems a little
dangerous.

I'll wire it up for clone_file_range for the next respin, but I'm still
a little worried.
