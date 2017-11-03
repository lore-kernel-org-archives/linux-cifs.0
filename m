From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/19] cifs: Add SendReceive3
Date: Thu, 2 Nov 2017 23:25:27 -0700
Message-ID: <20171103062527.GA8075@infradead.org>
References: <20171102070312.18903-1-lsahlber@redhat.com>
 <20171102070312.18903-2-lsahlber@redhat.com>
 <87o9okvkcd.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87o9okvkcd.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 02, 2017 at 03:14:26PM +0100, Aurélien Aptel wrote:
> I know this is kind of unrelated but I've been thinking to myself we
> should try to get rid of this dynamic allocation at some point.
> 
> IIUC the iovec never has more than a couple of elements, so we could
> have something like a fixed sized stack allocated iovec array +
> MAX_IOVEC_LENGTH macro.
> 
> Doing a kmalloc() for every packet defeats the purpose of the memory
> pool optimization we use for small/large buffers.

Yes.  You probably just want everyone to allocate an additional
entry in the vector for the header if needed, and just leave the
slot empty and start processing at offset for cases like SMB direct.
