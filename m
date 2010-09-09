From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/8] ntlmv2/ntlmssp  defines, data structures
Date: Thu, 09 Sep 2010 16:20:41 +0530
Message-ID: <4C88BC01.30503@suse.de>
References: <1283921040-12994-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283921040-12994-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/08/2010 10:14 AM, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Defining per smb connection structures, sdesc, ntlmssp_auth, cifs_secmech,
> and cphready.
> 
> Fields tilen and tilbob are session specific.
> 
> sdesc holds security descriptor, ntlmssp_auth holds secondary key which
> is a nonce that gets used as a key to generate signatures,
> ciphertext is genereated by rc4/arc4 encryption of secondary key using
> ntlmv2 session key and sent in the session key field of the type 3 message
> sent by the client during ntlmssp negotiation/exchange
> These are per session structures and secondary key and cipher text 
> get calculated only once per smb connection, during first smb session setup
> for that smb connection.
> 
> Field cphready is used to mark such that once secondary keys and ciphertext
> are calculated during very first smb session setup for a smb connection
> and ciphertext is sent to the server, the same does not happen during
> subsequent smb session setups/establishments.
> 
> if key exchange is negotiated between client and server, hmacmd5 and md5 hold
> respective crypto function/algorithm.
> 
> tilen and tiblob hold the length and blob that is target info or 
> attribute value (av) pairs, which is part of the authentication blob.
> These are per smb session fields.
> 
> Various defines are defined such as values used in AV pairs/Target Info pairs.
> And various key and hash sizes are also defined.
> 
> The reason mac_key was changed to session key is, this structure does not hold
> message authentication code, it holds the session key (for ntlmv2, ntlmv1 etc.).
> mac is generated as a signature in cifs_calc* functions.
> 

wondering whether making mac_key => session_key change a separate patch
would help/make it simpler..?



-- 
Suresh Jayaraman
