From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 4/8] ntlmv2/ntlmssp define, declare, and use crypto hash
 functions
Date: Thu, 09 Sep 2010 22:17:46 +0530
Message-ID: <4C890FB2.8010007@suse.de>
References: <1283921151-13090-1-git-send-email-shirishpargaonkar@gmail.com>	<4C88CC52.7080303@suse.de> <AANLkTinAA+5aXp0mO=h4f3TiLrL6PR4Uu_DHw2Ched3J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinAA+5aXp0mO=h4f3TiLrL6PR4Uu_DHw2Ched3J-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/09/2010 09:43 PM, Shirish Pargaonkar wrote:
> On Thu, Sep 9, 2010 at 7:00 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>=
 wrote:
>> On 09/08/2010 10:15 AM, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>>
>>> Allocate crypto hashing functions, ecurity descriptiors, and respec=
tive
>>> contexts when a smb/tcp connection is established.
>>> Release them when a tcp/smb connection is taken down.
>>>
>>> md5 and hmac-md5 are two crypto hashing functions that are used
>>> throught the life of an smb/tcp connection by various functions tha=
t
>>> calcualte signagure and ntlmv2 hash, HMAC etc.
>>>
>>>
>>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> =EF=BF=BDfs/cifs/cifsencrypt.c | =EF=BF=BD 71 +++++++++++++++++++++=
++++++++++++++++++++++++++++
>>> =EF=BF=BDfs/cifs/cifsproto.h =EF=BF=BD | =EF=BF=BD =EF=BF=BD2 +
>>> =EF=BF=BDfs/cifs/connect.c =EF=BF=BD =EF=BF=BD | =EF=BF=BD 16 +++++=
++++--
>>> =EF=BF=BD3 files changed, 86 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>>> index 4bdcf13..4772c4d 100644
>>> --- a/fs/cifs/cifsencrypt.c
>>> +++ b/fs/cifs/cifsencrypt.c
>>> @@ -369,3 +369,74 @@ void CalcNTLMv2_response(const struct cifsSesI=
nfo *ses,
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD hmac_md5_final(v2_session_response, &=
context);
>>> =EF=BF=BD/* =EF=BF=BD cifs_dump_mem("v2_sess_rsp: ", v2_session_res=
ponse, 32); */
>>> =EF=BF=BD}
>>> +
>>> +void
>>> +cifs_crypto_shash_release(struct TCP_Server_Info *server)
>>> +{
>>> + =EF=BF=BD =EF=BF=BD if (server->secmech.md5)
>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD crypt=
o_free_shash(server->secmech.md5);
>>> +
>>> + =EF=BF=BD =EF=BF=BD if (server->secmech.hmacmd5)
>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD crypt=
o_free_shash(server->secmech.hmacmd5);
>>> +
>>> + =EF=BF=BD =EF=BF=BD kfree(server->secmech.sdeschmacmd5);
>>> +
>>> + =EF=BF=BD =EF=BF=BD kfree(server->secmech.sdescmd5);
>>> +}
>>> +
>>> +int
>>> +cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
>>> +{
>>> + =EF=BF=BD =EF=BF=BD int rc;
>>> + =EF=BF=BD =EF=BF=BD unsigned int size;
>>> +
>>> + =EF=BF=BD =EF=BF=BD server->secmech.hmacmd5 =3D crypto_alloc_shas=
h("hmac(md5)", 0, 0);
>>> + =EF=BF=BD =EF=BF=BD if (!server->secmech.hmacmd5 ||
>>> + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD IS_ERR(server->secmech.hmacmd5)) {
>>
>> crypto_alloc_hash() seems to return a pointer to struct crypto_shash=
=2E
>> Would it be sufficient to use IS_ERR() to check?
>=20
> Suresh, not sure I understand, I check for NULL value of what
> crypto_alloc_shash()
> returns.  IS_ERR() is what crypto code is using.
> Copying crypto folks on the this thread.

I was suggesting to remove the NULL value check as checking for
IS_ERR(server->secmech.hmacmd5 alone can handle NULL cases and is
sufficient.



--=20
Suresh Jayaraman
