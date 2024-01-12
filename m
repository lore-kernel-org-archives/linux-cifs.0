Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002165D8E0;
	Fri, 12 Jan 2024 08:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rOCe7-0002nH-6T; Fri, 12 Jan 2024 09:12:07 +0100
Message-ID: <9144bdc5-36ea-498c-8ff6-1be9fc2d3d2a@leemhuis.info>
Date: Fri, 12 Jan 2024 09:12:06 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and
 file size with copy_file_range()"
To: Steve French <stfrench@microsoft.com>
Cc: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.com>,
 Shyam Prasad N <nspmangalore@gmail.com>,
 Rohith Surabattula <rohiths.msft@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 "Jitindar Singh, Suraj" <surajjs@amazon.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
 stable@vger.kernel.org, linux-cifs@vger.kernel.org,
 Linux regressions mailing list <regressions@lists.linux.dev>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 Salvatore Bonaccorso <carnil@debian.org>
References: <2023121124-trifle-uncharted-2622@gregkh>
 <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com>
 <ZZhrpNJ3zxMR8wcU@eldamar.lan>
 <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>
 <ZZk6qA54A-KfzmSz@eldamar.lan>
 <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info>
 <ZZ7Dy69ZJCEyKhhS@eldamar.lan> <2024011115-neatly-trout-5532@gregkh>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <2024011115-neatly-trout-5532@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1705047139;a5ce67ef;
X-HE-SMSGID: 1rOCe7-0002nH-6T

On 11.01.24 12:03, gregkh@linuxfoundation.org wrote:
> On Wed, Jan 10, 2024 at 05:20:27PM +0100, Salvatore Bonaccorso wrote:
>> On Sat, Jan 06, 2024 at 01:02:16PM +0100, Linux regression tracking (Thorsten Leemhuis) wrote:
>>> On 06.01.24 12:34, Salvatore Bonaccorso wrote:
>>>> On Sat, Jan 06, 2024 at 11:40:58AM +0100, Linux regression tracking (Thorsten Leemhuis) wrote:
>>>>>
>>>>> Does this problem also happen in mainline, e.g. with 6.7-rc8?
>>>> Thanks a lot for replying back. So far I can tell, the regression is
>>>> in 6.1.y only 
>>> Ahh, good to know, thx!
>>>
>>>> For this reason I added to regzbot only "regzbot ^introduced
>>>> 18b02e4343e8f5be6a2f44c7ad9899b385a92730" which is the commit in
>>>> v6.1.68.
>>> Which was the totally right thing to do, thx. Guess I sooner or later
>>> will add something like "#regzbot tag notinmainline" to avoid the
>>> ambiguity we just cleared up, but maybe that's overkill.
>> Do we have already a picture on the best move forward? Should the
>> patch and the what depends on it be reverted or was someone already
>> able to isolate where the problem comes from specifically for the
>> 6.1.y series? 
> I guess I can just revert the single commit here?  Can someone send me
> the revert that I need to do so as I get it right?

Steve what's you opinion on reverting this? From
https://lore.kernel.org/all/CAH2r5mu7e5-ORZbUyutteWVx2Nk6FPHfx7mMGCWSCEBAO6tdqg@mail.gmail.com/
it looks like you added the stable tag to the culprit on purpose.

FWIW, this thread stared there (just in case you missed earlier msgs):
https://lore.kernel.org/all/a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com/

Ciao, Thorsten
