From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH] cifs: Support for an upcall to map SID to an uid and a gid
Date: Sat, 11 Dec 2010 19:57:11 -0500
Message-ID: <AANLkTiniGp28dxZuoTcjyp0OMEoQ-7E0yE6T8B+VHOLj@mail.gmail.com>
References: <1291741872-22747-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101211111716.1e21be41@corrin.poochiereds.net>
	<AANLkTimiD_iAJveTFpsANQsJC_cUfRwHM=jO5FSoj4x_@mail.gmail.com>
	<20101211193003.4a11fc7f@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: dhowells@redhat.com, smfrench@gmail.com,
	samba-technical <samba-technical@lists.samba.org>,
	linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20101211193003.4a11fc7f@corrin.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Dec 11, 2010 at 7:30 PM, Jeff Layton <jlayton@samba.org> wrote:
>>
>> Will look into this. =A0One thing that concerns me is if a cached etnry
>> for a SID with its name and an id (either an uid or a gid), if that SID
>> now represents a different object and has differernt name, would
>> not cached info be incorrect? =A0Not sure if this can ever happen
>> or how would it happen and if it does, what would be a trigger
>> for a cache revalidation and purges!
>>
>
> Sure, mappings can change. But, you still have the same problem with
> what you're proposing in these patches. The userspace program isn't
> setting a timeout on the key. Once a mapping is put in the keyring,
> it's there until it's revoked. You probably want to set a max TTL for
> the entries in the cache regardless of what scheme is used.

I was under the impression that SIDs are never reused. Perhaps I am mistake=
n.

--=20
Regards,
Richard Sharpe
