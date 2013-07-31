From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NTLMSSP unix query info problem
Date: Wed, 31 Jul 2013 16:08:16 +0400
Message-ID: <CAKywueQdubd_WycmBpOcKi7A1WTjjNzX8szWg+7JGd+j5xSoow@mail.gmail.com>
References: <CAKywueTz3hRCgFB00dGPE3Bo2mnPN_efZCtzc-yc4c6umg0pUQ@mail.gmail.com>
	<CADT32eKTZgH0Tk9YJ9P2eZ_E8k6S9sye89d6syDTprgcP1dB+Q@mail.gmail.com>
	<CAKywueTOzbS_y0hgAjimjP6eXUaRhdBuveOusAaUxnusF-NunA@mail.gmail.com>
	<1375186459.4781.9.camel@pico.ipa.ssimo.org>
	<CAKywueRU4Hte6TnCCatPvL8DArun7FiLxZR10zRp4eGXykELyg@mail.gmail.com>
	<1375271807.4781.10.camel@pico.ipa.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Simo <s@ssimo.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375271807.4781.10.camel-fj0lwfvWodpMy5p6ylGyhR2eb7JE58TQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/7/31 Simo <s@ssimo.org>:
> On Wed, 2013-07-31 at 09:42 +0400, Pavel Shilovsky wrote:
>> 2013/7/30 Simo <s@ssimo.org>:
>> > Are you using unix extensions on SMB1 ?
>>
>> Yes.
>
> Well then that's likely the explanation, with Unix Extensions you gate
> case-sensitive matching, without (SMB2) you get standard Windows
> case-insensitive matching (on the server).

The problem is that the behavior is different for the same share with
Unix Ext on during negotiating SMB1 protocol and it depends on 'sec='
mount option.

-- 
Best regards,
Pavel Shilovsky.
