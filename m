Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584FEC433ED
	for <linux-cifs@archiver.kernel.org>; Sat, 15 May 2021 14:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2796D613D6
	for <linux-cifs@archiver.kernel.org>; Sat, 15 May 2021 14:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhEOO3D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 May 2021 10:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbhEOO3C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 15 May 2021 10:29:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10448C061573
        for <linux-cifs@vger.kernel.org>; Sat, 15 May 2021 07:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=UVfoV3IwAkDn6IJviKlYe2vCFBnCnIsjjYhm3sThn+Q=; b=PkKdVmRP62YcdialjKBWbzx+hR
        DJjQzTVCLoqNLfWi7LBJgOs0deM6BMWUy5zoVi+MOxbscxUY8qS37A09Xzs89HsGJBRU34UGC8lBm
        tNz/O1abinzZVb4tXm7jkFcIW3E8kwsFHB1QmrZdBpDvFj+haXszRKJa0Y4KnfRb77g8qa6eP8ZB6
        dDC7MpzpU4R7RVkyMxNqVK46pYTUuDHHkQ41ZSD7I6jaWerxEGdUEQ/WW7ieMwnvMV2xqT+qt3khC
        Y0CDIDCVBpZjYwouRiBefA3DvPyRVLfXOLTf7zTZBjVnyMXr5noNScZXmyyCrNLVsKfS6nmSV/xKd
        X11vZ3lXqP9eKex/dxx3+Ti2HZVJZXqtiqPOb3/JyU2yResznTqabLOV/WhKb2NaXG9oS3DBl6tVs
        oVnhU+u0kRd7y9OXGGwq6X/UyEclLYbB+BV5I5yxv0lVb0/rOk+nFAv7agSf8tI3E8QaIQGJFaq2D
        ulut8XJbxTs2DcJR5k3DkPe2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lhvGZ-0001K6-Fx; Sat, 15 May 2021 14:27:43 +0000
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: Do not use 0 as TreeID
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Marios Makassikis <mmakassikis@freebox.fr>,
        linux-cifsd-devel@lists.sourceforge.net,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <20210514125201.560775-1-mmakassikis@freebox.fr>
 <f053a063-c8e2-14c8-2c4f-a34c10c39fa1@samba.org>
 <CAKYAXd9xWW9VJ=EPrhgVUP+ES04zOnHcy4rkboAVYeOuE=bX=w@mail.gmail.com>
 <e03eb8d7-e964-5fa5-840d-9d3292d6d03f@samba.org>
 <CAKYAXd_64YRcho0Qnq+ccezVL7Tu2_9Jjb8PM+GDujZ9h8x6xw@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <d5f40ae9-ba89-3bad-1ed8-c4fe672bb0b9@samba.org>
Date:   Sat, 15 May 2021 16:27:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAKYAXd_64YRcho0Qnq+ccezVL7Tu2_9Jjb8PM+GDujZ9h8x6xw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KaCu1QG0EYLtl1fic0bXWhbD0RSb51kJ5"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KaCu1QG0EYLtl1fic0bXWhbD0RSb51kJ5
Content-Type: multipart/mixed; boundary="OfHi84suajsvgcqTxrmSkvlBNdhgAdPkD";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Marios Makassikis <mmakassikis@freebox.fr>,
 linux-cifsd-devel@lists.sourceforge.net,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Message-ID: <d5f40ae9-ba89-3bad-1ed8-c4fe672bb0b9@samba.org>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: Do not use 0 as TreeID
References: <20210514125201.560775-1-mmakassikis@freebox.fr>
 <f053a063-c8e2-14c8-2c4f-a34c10c39fa1@samba.org>
 <CAKYAXd9xWW9VJ=EPrhgVUP+ES04zOnHcy4rkboAVYeOuE=bX=w@mail.gmail.com>
 <e03eb8d7-e964-5fa5-840d-9d3292d6d03f@samba.org>
 <CAKYAXd_64YRcho0Qnq+ccezVL7Tu2_9Jjb8PM+GDujZ9h8x6xw@mail.gmail.com>
In-Reply-To: <CAKYAXd_64YRcho0Qnq+ccezVL7Tu2_9Jjb8PM+GDujZ9h8x6xw@mail.gmail.com>

--OfHi84suajsvgcqTxrmSkvlBNdhgAdPkD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 15.05.21 um 16:10 schrieb Namjae Jeon:
> 2021-05-15 17:57 GMT+09:00, Stefan Metzmacher <metze@samba.org>:
>>
>> Am 15.05.21 um 07:18 schrieb Namjae Jeon:
>>> 2021-05-14 22:11 GMT+09:00, Stefan Metzmacher via Linux-cifsd-devel
>>> <linux-cifsd-devel@lists.sourceforge.net>:
>>>>
>>>> Am 14.05.21 um 14:52 schrieb Marios Makassikis:
>>>>> Returning TreeID=3D0 is valid behaviour according to [MS-SMB2] 2.2.=
1.2:
>>>>>
>>>>>   TreeId (4 bytes): Uniquely identifies the tree connect for the
>>>>> command.
>>>>>   This MUST be 0 for the SMB2 TREE_CONNECT Request. The TreeId can =
be
>>>>>   any unsigned 32-bit integer that is received from a previous
>>>>>   SMB2 TREE_CONNECT Response. TreeId SHOULD be set to 0 for the
>>>>>   following commands:
>>>>>    [...]
>>>>>
>>>>> However, some client implementations reject it as invalid. Windows =
7/10
>>>>> assigns ids starting from 1, and samba4 returns a random uint32_t
>>>>> which suggests there may be other clients that consider it is
>>>>> invalid behaviour.
>>>>>
>>>>> While here, simplify ksmbd_acquire_smb2_tid. 0xFFFF is a reserved v=
alue
>>>>> for CIFS/SMB1:
>>>>>   [MS-CIFS] 2.2.4.50.2
>>>>>
>>>>>   TID (2 bytes): The newly generated Tree ID, used in subsequent CI=
FS
>>>>>   client requests to refer to a resource relative to the
>>>>>   SMB_Data.Bytes.Path specified in the request. Most access to the
>>>>>   server requires a valid TID, whether the resource is password
>>>>>   protected or not. The value 0xFFFF is reserved; the server MUST N=
OT
>>>>>   return a TID value of 0xFFFF.
>>>>>
>>>>> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
>>>>> ---
>>>>> Example library that treats zero TreeID as invalid:
>>>>>
>>>>> https://github.com/AgNO3/jcifs-ng/blob/master/src/main/java/jcifs/i=
nternal/smb2/tree/Smb2TreeConnectResponse.java#L201
>>>>>
>>>>>  mgmt/ksmbd_ida.c | 9 ++-------
>>>>>  1 file changed, 2 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/mgmt/ksmbd_ida.c b/mgmt/ksmbd_ida.c
>>>>> index 7eb6476..34e0d2e 100644
>>>>> --- a/mgmt/ksmbd_ida.c
>>>>> +++ b/mgmt/ksmbd_ida.c
>>>>> @@ -13,19 +13,14 @@ static inline int __acquire_id(struct ida *ida,=
 int
>>>>> from, int to)
>>>>>  #ifdef CONFIG_SMB_INSECURE_SERVER
>>>>>  int ksmbd_acquire_smb1_tid(struct ida *ida)
>>>>>  {
>>>>> -	return __acquire_id(ida, 0, 0xFFFF);
>>>>> +	return __acquire_id(ida, 1, 0xFFFF);
>>>>>  }
>>>>>  #endif
>>>>>
>>>>>  int ksmbd_acquire_smb2_tid(struct ida *ida)
>>>>>  {
>>>>> -	int id;
>>>>> +	return  __acquire_id(ida, 1, 0);
>>>>
>>>> I think that should be __acquire_id(ida, 1, 0xFFFFFFFF) (or a lower
>>>> constraint)
>>>>
>>>> 0xFFFFFFFF is used for compound requests to inherit the tree id from=
 the
>>>> previous request.
>>> Where is it defined in the specification ? As I know,
>>> SMB2_FLAGS_RELATED_OPERATIONS flags in smb header indicate inherit
>>> tree id in previous request.
>>
>> [MS-SMB2] 3.2.4.1.4 Sending Compounded Requests
>>
>> ...
>>
>>   The client MUST construct the subsequent request as it would do norm=
ally.
>> For any subsequent
>>   requests the client MUST set SMB2_FLAGS_RELATED_OPERATIONS in the Fl=
ags
>> field of the SMB2
>>   header to indicate that it is using the SessionId, TreeId, and FileI=
d
>> supplied in the previous
>>   request (or generated by the server in processing that request). For=
 an
>> operation compounded
>>   with an SMB2 CREATE request, the FileId field SHOULD be set to {
>> 0xFFFFFFFFFFFFFFFF,
>>   0xFFFFFFFFFFFFFFFF }.
>>
>> This only explicitly talks about FileId and I'm not any client would d=
o
>> that, but in theory it should be possible to
>> compound, the 2nd session setup request (of an anonymous authenticatio=
n)
>> with a tree connect request
>> and an open.
>>
>> Which means it's the safest behavior for a server to avoid 0 and all F=
 as
>> valid id,
>> there're still enough ids to use....
>>
>> It also makes sure that we don't end up with very confusing network
>> captures.
> Okay, I have checked cifs client code like the following.
>=20
>         if (request_type & CHAINED_REQUEST) {
>                 if (!(request_type & END_OF_CHAIN)) {
>                         /* next 8-byte aligned request */
>                         *total_len =3D DIV_ROUND_UP(*total_len, 8) * 8;=

>                         shdr->NextCommand =3D cpu_to_le32(*total_len);
>                 } else /* END_OF_CHAIN */
>                         shdr->NextCommand =3D 0;
>                 if (request_type & RELATED_REQUEST) {
>                         shdr->Flags |=3D SMB2_FLAGS_RELATED_OPERATIONS;=

>                         /*
>                          * Related requests use info from previous read=
 request
>                          * in chain.
>                          */
>                         shdr->SessionId =3D 0xFFFFFFFF;
>                         shdr->TreeId =3D 0xFFFFFFFF;
>                         req->PersistentFileId =3D 0xFFFFFFFF;
>                         req->VolatileFileId =3D 0xFFFFFFFF;
>                 }

Which seems actually wrong and should be 0xFFFFFFFFFFFFFFFF for all but T=
reeId...

metze



--OfHi84suajsvgcqTxrmSkvlBNdhgAdPkD--

--KaCu1QG0EYLtl1fic0bXWhbD0RSb51kJ5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmCf2loACgkQDbX1YShp
vVZFPw//fjm8U/OYGcoRMie+92U8I1WqhBexSMR4WlJqVZXJE1gUPwWKf0zlACfH
s61Yo3ooveTSuhnmiWpzytc1++iqnFo3l11SyoGqoY+MorFT4p1mSToOVJQ5m/YS
VZW0VPUJoNmnXHz6dU2pNbqc0sguWpoy3CShsHPQE4b+B44ZJ6GYJ7ahed/Kl25U
CqiimLQTPkaRdKGBAi0EuEYHAUWqX1By3sAGRFBP0OcGAPwU/PasyxjXhnljCnj3
W24z6oefAViqjQVqwVtSBe/fdFGgIjH60PrXR146cDc5sd2iO1rrCPxkjsy9bg/h
jBGaIThXj9gSRtz7c75P5E4PGAz++oxHc/OhswpH8M2Ps3BEuH7hclzjFUp8vnzj
ACSj6+c5sLxMYCCnQ3V9StiksnpE/BO+q6WtRBI3dU7MyXwyqZjkdSdklk7n2RjL
MT7N+N1YP+LifgnlbupRAVAT7zgs6FXPRUrS4sTbtDsDFTwBiauxN0glW9Fq+701
RbmcGb6p32q/1FWWZS1tXBKGdj83bLLuwLLKGZhvtrlLZWp2qkqUDk+BPQy0cCQi
ABYyc889Q6A4PDJAGqaqzSN0NQLUnGRGJ9P544sV0l4mpNcgS3ZkX++ryM2+zYRb
GBVbu6KSeJg43VpGdMfKkoV+Jqyz/VOBcKuqX9r4KuCQmyqZeJQ=
=elpI
-----END PGP SIGNATURE-----

--KaCu1QG0EYLtl1fic0bXWhbD0RSb51kJ5--
