From: Steve French <smfrench@gmail.com>
Subject: Re: [CIFS] [PATCH] consistently use smb_buf_length as be32 for cifs
 (try 3)
Date: Sat, 19 Mar 2011 22:05:43 -0500
Message-ID: <AANLkTi==ojddc91ruaLHJvY85_tHvNe1J+YVZi7fsj8n@mail.gmail.com>
References: <AANLkTimb8H=2hzNWUK_sQ=SMKhaQLrTQzA7ABiy_E4H5@mail.gmail.com>
	<20110317164446.GA26600@infradead.org>
	<AANLkTikqrGxG1RgUwFGNhoyyLc8ARiVvqQ8ULio8pz4f@mail.gmail.com>
	<20110318185154.GA8028@infradead.org>
	<20110319171735.429915b0@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110319171735.429915b0@corrin.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Mar 19, 2011 at 4:17 PM, Jeff Layton <jlayton@redhat.com> wrote=
:
> On Fri, 18 Mar 2011 14:51:54 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Thu, Mar 17, 2011 at 12:17:24PM -0500, Steve French wrote:
>> > If others feel strongly about this, I don't mind changing it as
>> > Christoph suggests but
>> > - to samba people, "incrementing the rfc1001 length" would be more
>> > recognizable (than opencoding the be32_add_cpu macro), and the
>> > function name was
>> > actually Jeff's suggestion which I liked.
>>
>> I don't mind the rfc1001 length per se. =A0What's totally braindead =
about
>> this is having an absolutely trivial wrapper for incrementing a fiel=
d,
>> which has a different name than the field it increments.
>>
>> If you feel strongly about the rfc1001 length just rename the field.
>>
>
> FWIW, the MS-SMB doc calls this value the "Stream Protocol Length". I=
t
> also mentions that this is actually a 24 bit field and the upper 8 bi=
ts
> are supposed to be zeroed out.
>
> Should this wrapper check for values that violate that? A little
> defensive coding in this area wouldn't hurt.

I agree, defensive code wouldn't hurt here. We do actually check IIRC
the first byte of it (which acts as an "rfc1001" command code, where
zero is what we want for most, in cifs_demultiplex_thread).   Of the
next 3 bytes, which serve as a length field, old servers had a small
maximum smb size, and thus only read two bytes, eventually some
servers allowed you to use just over 64K, and Samba has allowed more
than that for years.

--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
