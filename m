From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v2 0/6] ntlmv2 within ntlmssp - enable and sign using
 crypto apis
Date: Mon, 13 Sep 2010 05:27:44 -0500
Message-ID: <AANLkTikk=yNmm9z0rPhjRc+JQPeotkPscdw9GWQ3dP+p@mail.gmail.com>
References: <1284056215-959-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100912202701.1cd7d8bf@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100912202701.1cd7d8bf-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Sep 12, 2010 at 7:27 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, =A09 Sep 2010 13:16:55 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> Three major functionality changes
>>
>
> Maybe this should be 3 separate patchsets then? It would be best if
> these major functionality changes were bisectable. Also, these patche=
s
> mix a lot of trivial cleanup code in with the deltas that actually ma=
ke
> the major changes. Those should be separated.
>
> IOW, more patches that are smaller and targeted would be ideal.

It is probably easier to separate ntlmv2/ntlmssp authentication patch
but for signing, we need rc4/arcfour code which does not exist in cifs
and so we have to use linux kernel apis and lot of data structures that
get introduced in TCP_Server_Info structure.  Change from name
mac_key to session key would gate some of the changes in auth and
signing code. So I would really prefer to keep the patchset intact.

>
>>
>> Make NTLMv2 as a default authentication mechanism within NTLMSSP
>>
>> Enable cifs/smb signing
>>
>> Use Crypto sync hash APIs instead of cifs crypto functions to genere=
ate
>> various hashes such as arc4/rc4, md5, and hmac-md5 used during authe=
ntication
>> and smb/cifs signature generation
>>
>
> It seems like this set should be a net reduction in code or at least
> something closer to 0. This set should not be merged without an
> accompanying patch to remove the unused crypto code after the
> conversion to the kernel crypto APIs.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
