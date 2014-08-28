From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 2/3] common: add cifs support
Date: Thu, 28 Aug 2014 10:18:02 -0700
Message-ID: <20140828171802.GB20891@infradead.org>
References: <1409084918-17764-1-git-send-email-pshilovsky@samba.org>
 <1409084918-17764-3-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1409084918-17764-3-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 27, 2014 at 12:28:37AM +0400, Pavel Shilovsky wrote:
> +    - You can explicitly specify NFS or CIFS, otherwise the filesystem type will
> +      be autodetected from $TEST_DEV:
>        ./check -nfs [test(s)]

Can you take care of mentioning tmpfs as well, looks like it didn't get
added here when support was added.

>  	;;
> +    cifs)
> +	# Don't know how to check a CIFS filesystem, yet.
> +	;;

Will we ever find a way to sanity check a cifs fs? :)

Otherwise looks fine to me.
