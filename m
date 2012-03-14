From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 14 Mar 2012 16:08:56 -0500
Message-ID: <CAH2r5mvTnYnHZVQ3bxWGtkvJ4ZXAYHEzS8e+Bq1QSL6i09wCwg@mail.gmail.com>
References: <CAH2r5muUm-E5n6Le4JPnBZmKNJ46OJ8dYZdS9b79=O3UGif4Rg@mail.gmail.com>
	<90445c03-bbcc-4faf-afbf-fde4b1d17f05@zmail17.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <90445c03-bbcc-4faf-afbf-fde4b1d17f05-s/U0J+63Ool+R5eDjrG6zsCp5Q1pQRjfhaY/URYTgi6ny3qCrzbmXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 14, 2012 at 2:58 PM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> ----- Original Message -----
>> I don't mind reviewing this, but it does appear to change behaviour
>> significantly from existing code. =A0Does this fix a reported bug?
>>
>> The linux cifs kernel driver, like some other
>> network clients, allows partial option matching to ease
>> usability for users of other platforms (e.g. "pass" or
>> "passwd" or "password" are intentionally all accepted
>> since we match on the first four bytes of that keyword).
>> Is there a way to get that to work with your patchset.
>> I worry that some users will be confused that their
>> mount options won't work if this is taken.
>>
>
> The reason I was looking at this code was because I was helping Jeff =
include in the sloppy mount option for cifs. The current if/elseif bloc=
k is difficult to read through. There are also hidden gotchas like orde=
ring the if blocks correctly if in case a mount option is also a substr=
ing in a different mount option. The decision to use the standard token=
 parser was simply for consistency and to make the code easier to under=
stand.
>
> Multiple versions of mount options can be accepted for the same mount=
 option. For example, in the patch sent earlier, for the password, we a=
ccept the following mount options to pass the password.
>
>
> + =A0 =A0 =A0 { Opt_pass, "pass=3D%s" },
> + =A0 =A0 =A0 { Opt_pass, "password=3D%s" },
>
> So the user can use pass or password and they will both be accepted a=
s the mount option to set the password.
> We can add more options if I have missed any.
>
> The only difference I see is that the options matching is case sensit=
ive and therefore will reject upper case mount options.
>
> Also, in my opinion the number of mount options is large at the momen=
t and we should consider deprecating a few of the mount options.

We should have far fewer mount options with SMB2, so that will help
the usability.
With SMB2 there is far less need for the varoius mount options that
deal with compatibility to broken old servers or to workaround
protocol limitations,
and certain other features in SMB2 would be enabled by default and no
point in allowing them to be disabled unless we run into badly broken
smb2 servers.



--=20
Thanks,

Steve
