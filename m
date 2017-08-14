From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [[PATCH v1] 08/37] [CIFS] SMBD: Define packet format for SMBD
 data transfer message
Date: Mon, 14 Aug 2017 06:24:39 -0400
Message-ID: <1502706279.4978.3.camel@redhat.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
         <1501704648-20159-9-git-send-email-longli@exchange.microsoft.com>
         <20170813101510.GC17287@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813101510.GC17287-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 2017-08-13 at 03:15 -0700, Christoph Hellwig wrote:
> > +// SMBD data transfer packet with payload [MS-SMBD] 2.2.3
> > +struct smbd_data_transfer {
> > +	__le16 credits_requested;
> > +	__le16 credits_granted;
> > +	__le16 flags;
> > +	__le16 reserved;
> > +	__le32 remaining_data_length;
> > +	__le32 data_offset;
> > +	__le32 data_length;
> > +	__le32 padding;
> > +	char buffer[0];
> 
> Please use the actually standardized [] syntax for variable sized
> arrays.  Also normally this would be a __u8 to fit with the other
> types, but I haven't seen the usage yet.
> 

Yes, having a single-element array makes it harder to handle the
indexes, etc. Flexible arrays are better.
 
> > +} __packed;
> 
> The structure is natually packed already, no need to add the
> attribute.

I think this should remain on structs that are intended to go across the
wire. Could we ever end up with some exotic arch that stuffs some
padding in there? Maybe I'm just paranoid, but I don't see any harm in
leaving that here.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
