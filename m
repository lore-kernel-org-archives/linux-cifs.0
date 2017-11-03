From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/19] cifs: Add SendReceive3
Date: Thu, 2 Nov 2017 23:27:15 -0700
Message-ID: <20171103062715.GB8075@infradead.org>
References: <20171102070312.18903-1-lsahlber@redhat.com>
 <20171102070312.18903-2-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102070312.18903-2-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 02, 2017 at 06:02:54PM +1100, Ronnie Sahlberg wrote:
> This function is similar to SendReceive2 except it does not expect
> a 4 byte rfc1002 length header in the first io vector.

Can you give it a proper name?  cifs_ prefix, lower case with _
as the word delimiter.

Also please explain the strategy for phasing out the old API(s) so
that we won't have three around forever.
