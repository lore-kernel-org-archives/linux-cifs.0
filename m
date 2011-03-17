From: Steve French <smfrench@gmail.com>
Subject: Re: [CIFS] [PATCH] consistently use smb_buf_length as be32 for cifs
 (try 3)
Date: Thu, 17 Mar 2011 12:17:24 -0500
Message-ID: <AANLkTikqrGxG1RgUwFGNhoyyLc8ARiVvqQ8ULio8pz4f@mail.gmail.com>
References: <AANLkTimb8H=2hzNWUK_sQ=SMKhaQLrTQzA7ABiy_E4H5@mail.gmail.com>
	<20110317164446.GA26600@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110317164446.GA26600@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Mar 17, 2011 at 11:44 AM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> None of the other fields uses a wrapper, and the name is overly
> confusing. =A0I'd suggest to just opencode the be32_add_cpu instead o=
f
> wrapping it.

If others feel strongly about this, I don't mind changing it as
Christoph suggests but
- to samba people, "incrementing the rfc1001 length" would be more
recognizable (than opencoding the be32_add_cpu macro), and the
function name was
actually Jeff's suggestion which I liked.
- the other places that refer to this field aren't adding to the length=
=2E
- this is the only length field which is big endian (in the protocol)



--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
