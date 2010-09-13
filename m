From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v2 2/6] ntlmv2/ntlmssp ntlmssp autentication code
Date: Sun, 12 Sep 2010 21:43:01 -0500
Message-ID: <AANLkTimYvmWFBf9Ok3MXPNjk8HWstxDWrspZ2WtSPoTW@mail.gmail.com>
References: <1284055960-792-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100912085214.08fea91e@tlielax.poochiereds.net>
	<AANLkTintaxP-BGTRWH-3GmYERvM7g_WYXYYT0StZJaGj@mail.gmail.com>
	<20100912222506.21f1c032@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100912222506.21f1c032-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Sep 12, 2010 at 9:25 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> >
>> > Would it be reasonable to split the simple mac_key to session_key
>> > rename part into a separate patch from the ones that actually chan=
ge
>> > behavior?
>>
>> OK. But I am not sure what we are trying to achieve here churning
>> these patches so
>> many times for a simple change. =A0Not sure who the audience is.
>>
>
> I'm trying to achieve clarity and bisectability. By separating the
> trivial changes from the substantive ones, the patches become smaller
> and the changes they introduce are more evident.
>
> For the clarity piece, the audience is those of us who are spending
> time to review them (so far, Steve, Suresh and I). All of us have
> limited amounts of time available to spend on review. None of us
> want to spend time sifting through the trivial changes in these patch=
es
> to hunt down the ones that actually change behavior.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

OK, I will make the change. I am now not sure whether that should be
a separate patch altogether or one of the patches that belongs to this =
patchset
i.e. 2 of x or 3 of x etc..
