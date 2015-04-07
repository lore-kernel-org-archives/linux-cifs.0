From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Fix to convert SURROGATE PAIR filename
Date: Mon, 6 Apr 2015 22:28:53 -0500
Message-ID: <CAH2r5msSYMKB_RHdnW=eEPFggkkGPEDu4K+uOJB2svjX7ACN3g@mail.gmail.com>
References: <54D1C8EE.2030900@nttcom.co.jp> <CAH2r5ms-qB=MAxsk_CQAaLBcNK0a+c9VkDdZMV4wEXPvBBbQGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms-qB=MAxsk_CQAaLBcNK0a+c9VkDdZMV4wEXPvBBbQGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Other than the endian bug, the patch tested out fine.

On Mon, Apr 6, 2015 at 9:20 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Note build warnings (when running normal sparse checks during compile)
> looks like need to resolve endian errors so that this is sure to work
> in big endian, not just little endian boxes
>
> e.g.
>
> make C=1 M=fs/cifs modules CF=-D__CHECK_ENDIAN__
>
>   CHECK   fs/cifs/cifs_unicode.c
> fs/cifs/cifs_unicode.c:508:34: warning: incorrect type in assignment
> (different base types)
> fs/cifs/cifs_unicode.c:508:34:    expected restricted __le16
> [assigned] [usertype] dst_char
> fs/cifs/cifs_unicode.c:508:34:    got unsigned short [unsigned]
> [short] [usertype] <noident>
> fs/cifs/cifs_unicode.c:517:42: warning: incorrect type in assignment
> (different base types)
> fs/cifs/cifs_unicode.c:517:42:    expected restricted __le16
> [assigned] [usertype] dst_char
> fs/cifs/cifs_unicode.c:517:42:    got unsigned short [unsigned]
> [short] [usertype] <noident>
> fs/cifs/cifs_unicode.c:523:42: warning: incorrect type in assignment
> (different base types)
> fs/cifs/cifs_unicode.c:523:42:    expected restricted __le16
> [assigned] [usertype] dst_char
> fs/cifs/cifs_unicode.c:523:42:    got unsigned short [unsigned]
> [short] [usertype] <noident>
> fs/cifs/cifs_unicode.c:526:42: warning: incorrect type in assignment
> (different base types)
> fs/cifs/cifs_unicode.c:526:42:    expected restricted __le16
> [assigned] [usertype] dst_char
> fs/cifs/cifs_unicode.c:526:42:    got unsigned short [unsigned]
> [short] [usertype] <noident>
>
> On Wed, Feb 4, 2015 at 1:23 AM, Nakajima Akira
> <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
>> Garbled characters happen by using surrogate pair for filename.
>>   (replace each 1 character to ??)
>>
>> This causes
>> -- inode number duplication (when ?? and ?? exist) .
>> -- can't remove file, directory.
>> -- can't operate under directory.
>> -- auto-remount with noserverino.
>>
>>
>> [Steps to Reproduce]
>> client# touch $(echo -e '\xf0\x9d\x9f\xa3')
>> client# touch $(echo -e '\xf0\x9d\x9f\xa4')
>> client# ls -li
>>   You see same inode number, same filename(=?? and ??) .
>>
>>
>>
>> [BUG description]
>> Some functions do not consider about surrogate pair (and IVS).
>>
>> cifs_utf16_bytes()
>> -- return incorrect length, because of not considering about surrogate pair.
>>    This causes problem about SymbolicLink with surrogate pair filename.
>>
>> cifs_mapchar()
>> -- not considering about surrogate pair.
>>
>> cifs_from_utf16()
>> -- not convert surrogate pair from SMB response (from UTF-16 to UTF-8)
>>    , then ls shows garbled characters.
>>
>> cifsConvertToUTF16()
>> -- not convert surrogate pair when mapchars(SFM/SFU).
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
