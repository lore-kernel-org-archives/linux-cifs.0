From: Matthieu Patou <mat@samba.org>
Subject: Re: [PATCH 0/3] cifs.upcall: attempt to use AD-style service
	principals
Date: Tue, 15 Nov 2011 12:18:52 +0100
Message-ID: <4EC24A9C.7080301@samba.org>
Reply-To: mat@samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
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

On 14/11/2011 02:17, Jeff Layton wrote:

> We've had a request recently to allow cifs.upcall to use AD-style
> service principals. While trying to nail down what they need, I asked
> Simo his opinion on how best to pick a service principal for a given
> hostname. His suggestion was:
>
> 	INPUT: fooo
> 	TRY in order:
>    		FOOO$@REALM
> 		cifs/fooo.<guessed domain ?>@REALM
>    		host/fooo.<guessed domain ?>@REALM
>
> 	INPUT: bar.example.com
> 	TRY in order:
> 		cifs/bar.example.com@REALM
> 		BAR$@REALM
> 		host/bar.example.com@REALM
>
> This patchset attempts to embody that logic.
>
> Suggestions welcome. Those reviewing it, please pay particular attention
> to the scheme for guessing a domain name. I want to make certain that
> we're not opening up any security holes with that scheme.

Jeff, you have to pay attention to DFS volumes.
IE. if I want to mount //mydomain.corp/sysvol you will never get a 
ticket for cifs/mydomain.corp@REALM instead you need to locate with 
trans2 calls (for smb1, I don't remember the name for smb2) the domain 
controlers (DC) that could provide you the share.
For sysvol it's still quite simple but you can have other DFS volume 
that are not stored on DC, would be great to have DFS awareness in the 
cifs client.

Matthieu

-- 
Matthieu Patou
Samba Team
http://samba.org
