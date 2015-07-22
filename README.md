## Counting the prevelance of "just" in emails from the Enron email dataset

This project is inspired by a recent article by [Ellen Petry Leanse](https://www.linkedin.com/pulse/just-say-ellen-petry-leanse) where she suggests that gender disparities often exist in the way the word "just" is used in emails. Here we wish to quantify the prevelance of the word just by measuring its frequency in emails. We choose the Enron email data set as our collection of emails to measure the frequency of "just" since:
- the data is publicly available and free to use
- the data reflects emails sent in a corporate setting. That is the specific environment Ellen Petry Leanse suggests that use of the word "just" is especially harmful.

## Results
To focus on the people who were actively engaged in Enron, we select email senders who have sent 5 or more email messages in the data set. We call these the "active" participants in Enron and its company affairs. This leaves us with the top 25% of email senders.  

For each email message, we measure two quantities:
- the number of times the word "just" is used in each email message
- the number of character used in each email message

We then compute the median number of times each sender uses the word "just" in all of her/his email messages and also the median number of characters each sender uses in all of her/his email messages. Here we show the visualization of what the relationship between these statistics and the number of emails sent: 

<div>
    <a href="https://plot.ly/~crude2refined/1245/" target="_blank" title="&quot;just&quot; rate each sender uses in her/his emails from the Enron email dataset" style="display: block; text-align: center;"><img src="https://plot.ly/~crude2refined/1245.png" alt="&quot;just&quot; rate each sender uses in her/his emails from the Enron email dataset" style="max-width: 100%;width: 607px;"  width="607" onerror="this.onerror=null;this.src='https://plot.ly/404.png';" /></a>
    <script data-plotly="crude2refined:1245"  src="https://plot.ly/embed.js" async></script>
</div>

Click the figure above to interact with the data and results directly. 

## Credits
Many thanks to [Arne Hendrik Schulz](http://www.ahschulz.de/enron-email-data/) for processing the Enron email dataset.

