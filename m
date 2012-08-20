From: Jim Meyering <jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH] cifs: remove misleading strncpy: each name has length < 16
Date: Mon, 20 Aug 2012 20:40:10 +0200
Message-ID: <87628dmmph.fsf@rho.meyering.net>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-6-git-send-email-jim@meyering.net>
	<CAE2SPAbBmRov9qK2HiBQBQXaZpfJ8pmZJ-PL18FEyoZhzDza4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Bastien ROUCARIES <roucaries.bastien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE2SPAbBmRov9qK2HiBQBQXaZpfJ8pmZJ-PL18FEyoZhzDza4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bastien ROUCARIES's message of "Mon, 20 Aug 2012 19:36:26 +0200")
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Bastien ROUCARIES wrote:
> Le 20 ao=FBt 2012 19:29, "Jim Meyering" <jim-Oxw1nKZkIVjk1uMJSBkQmQ@public.gmane.org> a =E9crit=A0=
:
>>
>> From: Jim Meyering <meyering-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Each of the protocols[i].name strings (statically declared above)
>> has length less than 16, so this use of strncpy is misleading:
>> =A0 strncpy(pSMB->DialectsArray+count, protocols[i].name, 16);
>> Besides, if a new name were added with length N >=3D 16, the existin=
g
>> strncpy-using code would be buggy, creating a ->DialectsArray buffer
>> containing N-16+1 unset bytes where the NUL terminator should have
>> been. =A0Instead, traverse the name only once go get its length,
>> use a BUG_ON assertion to enforce the length restriction
>> and use memcpy to perform the copy.
>
> Could you use ARRAY_SIZE instead of hard coding 16?

Not that I can see: the DialectsArray member is declared like this:

    typedef struct negotiate_req {
            struct smb_hdr hdr;	/* wct =3D 0 */
            __le16 ByteCount;
            unsigned char DialectsArray[1];
    } __attribute__((packed)) NEGOTIATE_REQ;

=2E..
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 074923c..16a9018 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -441,8 +441,10 @@ CIFSSMBNegotiate(const unsigned int xid, struct=
 cifs_ses
> *ses)
>>
>> =A0 =A0 =A0 =A0 count =3D 0;
>> =A0 =A0 =A0 =A0 for (i =3D 0; i < CIFS_NUM_PROT; i++) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy(pSMB->DialectsArray+count, pro=
tocols[i].name, 16);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 count +=3D strlen(protocols[i].name) +=
 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t len =3D strlen(protocols[i].nam=
e);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(len >=3D 16);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(pSMB->DialectsArray+count, prot=
ocols[i].name, len + 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 count +=3D len + 1;
