From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH 1/7] cifs: Bypass windows extended security for ntlmv2
 negotiate
Date: Fri, 22 Aug 2014 16:07:29 +0900
Message-ID: <004601cfbdd7$bca015e0$35e041a0$@samsung.com>
References: <003401cfbc62$f505f920$df11eb60$@samsung.com>
 <1408681626.11134.20.camel@pico.ipa.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: 'Steve French' <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	'Shirish Pargaonkar' <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	'Pavel Shilovsky' <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	'Ashish Sangwan' <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: 'Simo' <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1408681626.11134.20.camel-fj0lwfvWodpMy5p6ylGyhR2eb7JE58TQ@public.gmane.org>
Content-language: ko
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


> This patch is not addressing the problem in the correct way.
> The server should send the time in the challenge message targetinfo data
> (see MS-NLMP and search for MsvAvTimestamp in 2.2.2.1 and 3..5.1.2),
> only if it is not available the currentime should be used (if you have
> to pick the current time I guess you can employ tricks to try to get one
> as close as possible to the server time by other means).
> 
> It is not clear to me whether the code parses the challenge messages's
> targetinfo field, if it doesn't it should.
Okay, I will check your point.

Thanks for your reply :)
> 
> Simo.
