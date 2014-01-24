From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: Problem with connecting to SMB server in 3.9.11 kernel.
Date: Thu, 23 Jan 2014 21:41:08 -0800
Message-ID: <52E1FCF4.5040504@candelatech.com>
References: <52DAB72C.9030305@candelatech.com>	<CADT32eK5_duGPjJy2Q=2-SOfN1R+Msx10RJ7wk+Zzsz+xt_-Rw@mail.gmail.com>	<0DF7592FDA7A4C428E3B3D14C1D69BDAADCF8D@AUSP01DAG0309.collaborationhost.net> <CADT32eKGPu_3bNRL9bar+3RO74KXD=YKQvsC49635drWFL+63A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"c-dl-nb-mt-nic-validation (dl-nb-mt-nic-validation-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org)"
	<dl-nb-mt-nic-validation-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"Amit Haval (India Bangalore)" <amit.haval-ZIEO9HjW1UBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKGPu_3bNRL9bar+3RO74KXD=YKQvsC49635drWFL+63A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 01/20/2014 07:12 PM, Shirish Pargaonkar wrote:
> I will spend more time later tonight/tomorrow but it could be related to
> cifs client not using Target received in NTLMSSP Challenge response from
> the server (since the bit Target Type Domain in flags is set) while
> constructing NTLMSSP Authenticate message. Just a guess.

Did you have any luck with this?

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
