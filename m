From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: ignore everything in SPNEGO blob after mechTypes
Date: Sun, 17 Mar 2013 17:00:27 -0500
Message-ID: <CAH2r5muew1fSju_MuzRSETGhzb4Rv-R7kdjV0fVHsNXABq=wNw@mail.gmail.com>
References: <1363009939-2264-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mtcACcO5YfVzRptJO2ob=SYEgVyTtHBUc7XZS_n57XjAw@mail.gmail.com>
	<1363554854.27367.8.camel@jesse>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs@vger.kernel.org, jason@jacknife2.dns2go.com,
	samba-technical <samba-technical@lists.samba.org>,
	Jeff Layton <jlayton@redhat.com>, elliot.li.tech@gmail.com
To: Andrew Bartlett <abartlet@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1363554854.27367.8.camel@jesse>
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

On Sun, Mar 17, 2013 at 4:14 PM, Andrew Bartlett <abartlet@samba.org> wrote:
> On Sun, 2013-03-17 at 09:37 -0500, Steve French wrote:
>> The existing code is trying to dump the "principal" from the
>> mechListMic (presumably for debugging) in the SMB negotiate response.
>> In the trace I looked at Samba server set it to "NONE"  - is there a
>> case where we would ever need that?
>
> No, the "principal" should never be used, and isn't even useful for
> debugging as you should just never use it.  It can be set to strange and
> invalid values such as NONE and rfc....should_ignore

Thanks - then it makes more sense to do as Jeff suggested and removing
the extra parsing.


-- 
Thanks,

Steve
