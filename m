From: Vinay Sawal <vinaysawal@gmail.com>
Subject: Re: [PATCH] FC: cifs: Initialized an uninitialized variable
Date: Mon, 7 Mar 2011 20:48:50 -0800
Message-ID: <AANLkTi=bLX_mz6fRJxWEcfwpq9T+7gYximLJrdY1K1EY@mail.gmail.com>
References: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
	<20110308042601.GX22723@ZenIV.linux.org.uk>
	<AANLkTi==7wv6mrL5OWkGKxyc7GbKPH5+kgkCBNUcj3im@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro@zeniv.linux.org.uk>, sfrench@samba.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi==7wv6mrL5OWkGKxyc7GbKPH5+kgkCBNUcj3im@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Mar 7, 2011 at 8:38 PM, Steve French <smfrench@gmail.com> wrote=
:
> On Mon, Mar 7, 2011 at 10:26 PM, Al Viro <viro@zeniv.linux.org.uk> wr=
ote:
>> On Mon, Mar 07, 2011 at 08:00:09PM -0800, Vinay Sawal wrote:
>>> Removed a compile time warning by initializing an uninitialized var=
iable.
>>
>>> - =A0 =A0 int rc;
>>> + =A0 =A0 int rc =3D -EFAULT;
>>
>> Why is that the right thing to do? =A0Other than "it made the compil=
er to
>> STFU, therefore it is Good(tm)", please.
>
> Hard to disagree with Al's logic, although changing the scope of rc t=
o
> within the for loop might also make both your compiler happy and more
> sense. =A0 In any case, I prefer real bug fixes.

Completely agree. Thanks for the clarification. Sorry for the inconveni=
ence.

Thanks,
Vinay




>
>
> --
> Thanks,
>
> Steve
>
