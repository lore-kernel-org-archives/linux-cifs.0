From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [CIFS] [PATCH] consistently use smb_buf_length as be32 for cifs
 (try 3)
Date: Fri, 18 Mar 2011 14:51:54 -0400
Message-ID: <20110318185154.GA8028@infradead.org>
References: <AANLkTimb8H=2hzNWUK_sQ=SMKhaQLrTQzA7ABiy_E4H5@mail.gmail.com>
 <20110317164446.GA26600@infradead.org>
 <AANLkTikqrGxG1RgUwFGNhoyyLc8ARiVvqQ8ULio8pz4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikqrGxG1RgUwFGNhoyyLc8ARiVvqQ8ULio8pz4f@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Mar 17, 2011 at 12:17:24PM -0500, Steve French wrote:
> If others feel strongly about this, I don't mind changing it as
> Christoph suggests but
> - to samba people, "incrementing the rfc1001 length" would be more
> recognizable (than opencoding the be32_add_cpu macro), and the
> function name was
> actually Jeff's suggestion which I liked.

I don't mind the rfc1001 length per se.  What's totally braindead about
this is having an absolutely trivial wrapper for incrementing a field,
which has a different name than the field it increments.

If you feel strongly about the rfc1001 length just rename the field.

