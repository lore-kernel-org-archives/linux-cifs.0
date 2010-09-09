From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/8] ntlmv2/ntlmssp  defines, data structures
Date: Thu, 09 Sep 2010 16:01:14 +0530
Message-ID: <4C88B772.40701@suse.de>
References: <1283921040-12994-1-git-send-email-shirishpargaonkar@gmail.com> <20100908155444.0b15a287@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100908155444.0b15a287-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/09/2010 01:24 AM, Jeff Layton wrote:
> On Tue,  7 Sep 2010 23:44:00 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> 
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Defining per smb connection structures, sdesc, ntlmssp_auth, cifs_secmech,
>> and cphready.
>>
>> Fields tilen and tilbob are session specific.
>>
>> sdesc holds security descriptor, ntlmssp_auth holds secondary key which
>> is a nonce that gets used as a key to generate signatures,
>> ciphertext is genereated by rc4/arc4 encryption of secondary key using
>> ntlmv2 session key and sent in the session key field of the type 3 message
>> sent by the client during ntlmssp negotiation/exchange
>> These are per session structures and secondary key and cipher text 
>> get calculated only once per smb connection, during first smb session setup
>> for that smb connection.
>>
>> Field cphready is used to mark such that once secondary keys and ciphertext
>> are calculated during very first smb session setup for a smb connection
>> and ciphertext is sent to the server, the same does not happen during
>> subsequent smb session setups/establishments.
>>
>> if key exchange is negotiated between client and server, hmacmd5 and md5 hold
>> respective crypto function/algorithm.
>>
>> tilen and tiblob hold the length and blob that is target info or 
>> attribute value (av) pairs, which is part of the authentication blob.
>> These are per smb session fields.
>>
>> Various defines are defined such as values used in AV pairs/Target Info pairs.
>> And various key and hash sizes are also defined.
>>
>> The reason mac_key was changed to session key is, this structure does not hold
>> message authentication code, it holds the session key (for ntlmv2, ntlmv1 etc.).
>> mac is generated as a signature in cifs_calc* functions.
>>
>> Mark dependency on crypto modules in Kconfig.
>>
> 
> I guess I didn't state this clearly enough in my original emails, but...
> 
> Typically, this sort of patch will get you a strong NAK on LKML. Adding
> new data structures before you have code that actually uses it is
> frowned upon as it makes the code harder to review. We can't tell what
> code is actually using the new stuff and whether the fields you've
> added make sense.
> 

+1

It's always better to make every patch self-contained whenever possible,
compilable by itself with no more/no less than required code.

I think it helps:
  - to make review easier
  - when reverting changes. For e.g. if we introduce a data structure in
    patch 1 and use it in patch 3 and say in future we want to revert
    patch 3, there is a good chance that the related change in patch 1
    would still remains lurking around.


-- 
Suresh Jayaraman
