From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem with connecting to SMB server in 3.9.11 kernel.
Date: Sat, 25 Jan 2014 09:03:40 -0600
Message-ID: <CADT32eKSr0ki7WzxPiZ17W2s8mqf0WG3z80KDrwTqdMYWORYEw@mail.gmail.com>
References: <52DAB72C.9030305@candelatech.com>
	<CADT32eK5_duGPjJy2Q=2-SOfN1R+Msx10RJ7wk+Zzsz+xt_-Rw@mail.gmail.com>
	<0DF7592FDA7A4C428E3B3D14C1D69BDAADCF8D@AUSP01DAG0309.collaborationhost.net>
	<CADT32eKGPu_3bNRL9bar+3RO74KXD=YKQvsC49635drWFL+63A@mail.gmail.com>
	<52E1FCF4.5040504@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Amit Haval (India Bangalore)" <amit.haval-ZIEO9HjW1UBWk0Htik3J/w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"c-dl-nb-mt-nic-validation (dl-nb-mt-nic-validation-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org)"
	<dl-nb-mt-nic-validation-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E1FCF4.5040504-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I want to code to use Target Name instead of using domain name from
the avpair info received in type 2 ntlmssp challenge message from the server
to calculate ntlmv2 response within ntlmssp.
Will post a preliminary patch to try out with that code change (hopefully
in a day or two).  That is one code change I think might work.

On Thu, Jan 23, 2014 at 11:41 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
> On 01/20/2014 07:12 PM, Shirish Pargaonkar wrote:
>>
>> I will spend more time later tonight/tomorrow but it could be related to
>> cifs client not using Target received in NTLMSSP Challenge response from
>> the server (since the bit Target Type Domain in flags is set) while
>> constructing NTLMSSP Authenticate message. Just a guess.
>
>
> Did you have any luck with this?
>
> Thanks,
>
> Ben
>
> --
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Candela Technologies Inc  http://www.candelatech.com
>
