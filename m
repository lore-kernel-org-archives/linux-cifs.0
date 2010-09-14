From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v3 3/4 cifs] NTLMv2/NTLMSSP define crypto hash functions
 and create and send keys needed for key exchange
Date: Tue, 14 Sep 2010 09:36:19 -0500
Message-ID: <AANLkTi=E+4m+=HhXQiuMMW9rWw0jdyZUhOk=CYbXN+EV@mail.gmail.com>
References: <1284405339-31226-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100914083358.45c05914@corrin.poochiereds.net>
	<AANLkTim_S1kxVGRs-q1kSTAtsEvEE9ey-M2Aeb=yt76k@mail.gmail.com>
	<20100914103314.55c198ed@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100914103314.55c198ed-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 14, 2010 at 9:33 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 14 Sep 2010 09:15:38 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is=
 an empirical value, large enought to
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ho=
ld authenticate message, max 10 of
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* av=
 paris, doamin,user,workstation mames,
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fl=
ags etc..
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmssp=
blob =3D kmalloc(5 *
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct _AUTHENTICATE_MESSAGE),
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 GFP_KERNEL);
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^=
^ when does this get freed?
>>
>> It gets freed in build_ntlmssp_auth_blob, once the contents are copi=
ed.
>>
>
> I don't think it does. It gets passed to that function as the
> 'pbuffer', and then cast to 'sec_blob'. I don't see where it gets fre=
ed
> at all.
>
> Even if you're correct though, that's really messy and unclear. I
> think it would be best to free it in this function before you exit th=
at
> block.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Sure, I think that would be clearer.
